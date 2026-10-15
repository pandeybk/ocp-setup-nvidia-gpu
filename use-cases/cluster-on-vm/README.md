# Cluster nodes are VMs

OCP workers on AWS/Azure/GCP/vSphere **are** VMs. The hypervisor already attached the GPU (passthrough or vGPU) into that worker. Inside the guest it looks like a normal NVIDIA device.

```bash
oc get nodes -l node-role.kubernetes.io/gpu
oc get nodes -o custom-columns=NAME:.metadata.name,GPU:.status.allocatable.nvidia\.com/gpu
```

Use `operator/` plus a **container** use case (`exclusive`, `time-slicing`, `mps`). No VFIO / CNV config.

CNV GPU (VMs **on** OpenShift) needs **bare-metal** workers. Nested GPU into a VM that is already a VM is not this path — use `vm-passthrough` / `vm-vgpu` on BM.
