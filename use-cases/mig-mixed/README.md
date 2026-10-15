# MIG mixed

Heterogeneous slices on one node. Pods request `nvidia.com/mig-<profile>` (not `nvidia.com/gpu`). Needs a MIG-capable GPU.

```bash
oc apply -k use-cases/mig-mixed
oc adm drain <gpu-node> --ignore-daemonsets --delete-emptydir-data
oc label node <gpu-node> nvidia.com/mig.config=all-balanced --overwrite
oc get node <gpu-node> --show-labels | tr ',' '\n' | grep nvidia.com
oc adm uncordon <gpu-node>
```

Other labels: `all-1g.5gb`, `all-2g.10gb`, or a key from `custom-mig-config.yaml`. Workload: `resources.limits["nvidia.com/mig-1g.5gb"]: 1`.
