# AWS GPU MachineSet

Manual only. Not in GitOps. Clones a worker MachineSet (AMI, IAM, subnet, SGs).

GPU MachineSets are named `*-gpu-nvidia-<type>` and labeled `gpu=true`.

| Target | Instance | GPU | MachineSet | Node labels |
|---|---|---|---|---|
| `add-nvidia-l4` | `g6.8xlarge` | NVIDIA L4 | `*-gpu-nvidia-l4` | `gpu`, `nvidia-l4` |
| `add-nvidia-t4` | `g4dn.xlarge` | NVIDIA T4 | `*-gpu-nvidia-t4` | `gpu`, `nvidia-t4` |
| `add-nvidia-a10g` | `g5.2xlarge` | NVIDIA A10G | `*-gpu-nvidia-a10g` | `gpu`, `nvidia-a10g` |

```bash
make add-nvidia-l4
make add-nvidia-t4
make add-nvidia-a10g
```

```bash
oc get machineset -n openshift-machine-api -l gpu=true
oc get nodes -l node-role.kubernetes.io/nvidia-l4
oc get nodes -l node-role.kubernetes.io/nvidia-t4
oc get nodes -l node-role.kubernetes.io/nvidia-a10g
```

`GPU_REPLICAS=1` `GPU_SOURCE_MACHINESET=` (auto worker `*-compute`).
