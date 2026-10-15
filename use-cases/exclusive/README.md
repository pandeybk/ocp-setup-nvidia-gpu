# Exclusive GPU

1 pod gets the whole GPU. Default after `oc apply -k operator`. Apply this to undo time-slicing / MPS.

```bash
oc apply -k use-cases/exclusive
oc label node <gpu-node> nvidia.com/mig.config=all-disabled --overwrite
oc get nodes -o custom-columns=NAME:.metadata.name,GPU:.status.allocatable.nvidia\.com/gpu
```

Workload: `resources.limits["nvidia.com/gpu"]: 1`
