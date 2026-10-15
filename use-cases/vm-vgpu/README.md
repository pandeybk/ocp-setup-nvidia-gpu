# VM vGPU (OpenShift Virtualization)

NVIDIA vGPU (mediated devices) into KubeVirt VMs. **Bare-metal** worker. Licensed vGPU Manager image from NVIDIA Licensing Portal. Node cannot also run GPU containers.

Ampere+ : enable SR-IOV in BIOS. Guest driver is **not** installed by the operator — install it inside the VM.

```bash
# 1. Build/push vgpu-manager, set repository/version in clusterpolicy-patch.yaml
# 2. Create pull secret private-registry-secret in nvidia-gpu-operator
# AMD: swap iommu-intel.yaml → iommu-amd.yaml in kustomization.yaml
oc apply -k use-cases/vm-vgpu
oc label node <gpu-node> nvidia.com/gpu.workload.config=vm-vgpu --overwrite
oc label node <gpu-node> nvidia.com/vgpu.config=A10-8Q --overwrite   # or T4-8Q, L4-8Q, default

oc get node <gpu-node> -o json | jq '.status.allocatable | with_entries(select(.key|startswith("nvidia.com/")))'
```

Merge `hyperconverged-snippet.yaml` into HCO (`mdevNameSelector` + `resourceName` must match allocatable). Then `vm-example.yaml`.
