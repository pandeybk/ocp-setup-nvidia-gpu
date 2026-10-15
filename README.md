# NVIDIA GPU on OpenShift

Order: **GPU node → NFD → GPU Operator CSV Succeeded → ClusterPolicy → `nvidia.com/gpu`**.

```
operator/     NFD + NVIDIA GPU Operator + ClusterPolicy
tests/        gpu-smi Job, gpu-debug Pod, cuda-vectoradd Job
llmd/         GPU LLMInferenceService (needs OpenShift AI)
use-cases/    exclusive, time-slicing, MPS, MIG, DCGM, VM passthrough/vGPU
```

## 1. GPU node

Need a Ready node with an NVIDIA GPU, labeled `node-role.kubernetes.io/gpu=""`. How you add the node depends on the platform.

```bash
oc get nodes -o wide
oc get nodes -l node-role.kubernetes.io/gpu
```

### Cloud IPI (AWS, Azure, GCP)

Machine API creates the VM. Clone a worker MachineSet. Example AWS: `instanceType: g6.8xlarge`, `replicas: 1`, label `node-role.kubernetes.io/gpu: ""`.

```bash
oc get machinesets -n openshift-machine-api
oc get machines -n openshift-machine-api
oc get nodes -l node-role.kubernetes.io/gpu
```

### Bare metal

No MachineSet. The host is already (or will be) a node. Confirm it, then label it.

```bash
oc get nodes -o wide
oc describe node <gpu-node> | grep -A8 'Addresses:\|Capacity:\|Allocatable:'
oc label node <gpu-node> node-role.kubernetes.io/gpu=""
oc get nodes -l node-role.kubernetes.io/gpu
```

Bare Metal IPI (Metal3): provision a `BareMetalHost` that has the GPU. Do **not** clone a MachineSet or set a cloud `instanceType`.

```bash
oc get bmh -A
oc get machines -n openshift-machine-api
```

UPI / assisted / agent-based: empty `machinesets` is normal. Label the node and continue.

## 2. Operator

```bash
oc apply -k operator
# or: oc apply -k .
oc get csv -n openshift-nfd
oc get csv -n nvidia-gpu-operator
oc get nodefeaturediscovery -n openshift-nfd
oc get clusterpolicy gpu-cluster-policy
```

Wait CSV **Succeeded**. Then ClusterPolicy rolls driver + device plugin (10–20 min).

```bash
oc get pods -n nvidia-gpu-operator -o wide
oc get ds -n nvidia-gpu-operator
DRIVER=$(oc get pods -n nvidia-gpu-operator -l app=nvidia-driver-daemonset -o jsonpath='{.items[0].metadata.name}')
oc exec -n nvidia-gpu-operator "$DRIVER" -c nvidia-driver-ctr -- nvidia-smi
```

```bash
oc get nodes -o custom-columns=NAME:.metadata.name,GPU:.status.allocatable.nvidia\.com/gpu
```

Must show `nvidia.com/gpu: 1`.

## 3. Use cases

Pick one sharing or VM mode. Dashboard can stack with container modes.

```bash
oc apply -k use-cases/exclusive        # 1:1 GPU (default / undo sharing)
oc apply -k use-cases/time-slicing
oc apply -k use-cases/mps
oc apply -k use-cases/mig-single
oc apply -k use-cases/mig-mixed
oc apply -k use-cases/dashboard        # Observe → Dashboards → NVIDIA DCGM Exporter
# OCP workers are VMs (AWS g6, …): see use-cases/cluster-on-vm
oc apply -k use-cases/vm-passthrough   # CNV: whole GPU into a VM (bare metal)
oc apply -k use-cases/vm-vgpu          # CNV: NVIDIA vGPU into a VM (bare metal)
```

Each folder has its own `README.md`.

## 4. Test pods

```bash
oc apply -k tests
oc logs -n gpu-test job/gpu-smi -f
oc logs -n gpu-test job/cuda-vectoradd -f
oc exec -n gpu-test gpu-debug -- nvidia-smi
```

```bash
oc delete -k tests
```

## 5. LLMInferenceService (OpenShift AI)

Needs KServe CRD + `data-science-gateway-class` + GPU.

```bash
oc apply -k llmd
oc get llminferenceservice -n gpu-test
oc get pods -n gpu-test -o wide
POD=$(oc get pods -n gpu-test -l app.kubernetes.io/component=llminferenceservice-workload -o jsonpath='{.items[0].metadata.name}')
oc exec -n gpu-test "$POD" -c main -- nvidia-smi
```

In-cluster: `https://llama-31-8b-kserve-workload-svc.gpu-test:8000`

## Failures

| See | Meaning |
|---|---|
| Node Ready, GPU empty | Driver/plugin not Ready |
| Pending `Insufficient nvidia.com/gpu` | Device plugin has not advertised GPU |
| Driver CrashLoop / ImagePull | Catalog, pull secret, Driver Toolkit |
| llmd apply fails on CRD | OpenShift AI / KServe not installed |
