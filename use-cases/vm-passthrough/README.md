# VM GPU passthrough (OpenShift Virtualization)

Whole physical GPU into a KubeVirt VM via VFIO. **Bare-metal** worker. Node cannot also run GPU containers.

Needs: CNV installed, IOMMU in BIOS (`intel_iommu` / `amd_iommu`).

```bash
# AMD: swap iommu-intel.yaml → iommu-amd.yaml in kustomization.yaml
oc apply -k use-cases/vm-passthrough
oc label node <gpu-node> nvidia.com/gpu.workload.config=vm-passthrough --overwrite

oc get node <gpu-node> -o json | jq '.status.allocatable | with_entries(select(.key|startswith("nvidia.com/")))'
# lspci -nnk -d 10de:   → pciDeviceSelector 10DE:<id>
```

Merge `hyperconverged-snippet.yaml` into `kubevirt-hyperconverged` (do not apply the snippet alone). Edit PCI id + resourceName to match allocatable.

```bash
oc apply -f use-cases/vm-passthrough/vm-example.yaml   # after HCO + deviceName match
```

Guest: install NVIDIA datacenter driver inside the VM. No live migration.
