# MPS

NVIDIA Multi-Process Service. Multiple CUDA contexts on one GPU. Better concurrency than time-slicing; still no MIG-level isolation.

```bash
oc apply -k use-cases/mps
oc get nodes -o custom-columns=NAME:.metadata.name,GPU:.status.allocatable.nvidia\.com/gpu
```

Default `any` = 10 replicas. Workload: `nvidia.com/gpu: 1`. Do not stack with time-slicing.
