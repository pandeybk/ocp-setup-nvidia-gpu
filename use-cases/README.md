# GPU use cases

Apply **operator** first. Then **one** sharing / VM mode. Dashboard can stack with container modes.

A node is **one** of: GPU containers, VM passthrough, or VM vGPU — not mixed.

| Folder | Use when |
|---|---|
| `exclusive/` | 1 pod = 1 physical GPU (default / undo sharing and VM modes) |
| `time-slicing/` | Many pods share one GPU (no isolation) |
| `mps/` | MPS sharing (better concurrency than time-slice) |
| `mig-single/` | Homogeneous MIG; pods still request `nvidia.com/gpu` |
| `mig-mixed/` | Heterogeneous MIG; pods request `nvidia.com/mig-*` |
| `dashboard/` | Observe → Dashboards → NVIDIA DCGM Exporter |
| `cluster-on-vm/` | OCP workers **are** VMs (cloud). GPU already in the guest |
| `vm-passthrough/` | CNV VM gets the whole GPU (VFIO). Bare metal |
| `vm-vgpu/` | CNV VM gets NVIDIA vGPU (mdev). Bare metal + license |

```bash
oc apply -k use-cases/<name>
```

Add a new folder the same way: `kustomization.yaml` + manifests + `README.md`.
