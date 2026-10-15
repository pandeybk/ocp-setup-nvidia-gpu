# Time-slicing

Many pods share one GPU by time. No memory isolation. Good for light inference.

Default `any` = 4 replicas per GPU. Product keys (L4, T4, A100, …) are in the ConfigMap; label a node to use one.

```bash
oc apply -k use-cases/time-slicing
# optional per-node (else default "any"):
oc label node <gpu-node> nvidia.com/device-plugin.config=L4 --overwrite
oc get nodes -o custom-columns=NAME:.metadata.name,GPU:.status.allocatable.nvidia\.com/gpu
```

Expect `nvidia.com/gpu` ≈ physical GPUs × replicas. Workload still requests `nvidia.com/gpu: 1`.
