# MIG single

Hardware partitions (Ampere+ MIG GPUs: A100, A30, H100, H200). All slices look like `nvidia.com/gpu`. Drain GPU workloads before labeling.

```bash
oc apply -k use-cases/mig-single
oc adm drain <gpu-node> --ignore-daemonsets --delete-emptydir-data
oc label node <gpu-node> nvidia.com/mig.config=all-1g.5gb --overwrite
# wait nvidia.com/mig.config.state=success
oc get node <gpu-node> -o jsonpath='{.metadata.labels}' | tr ',' '\n' | grep nvidia.com
oc adm uncordon <gpu-node>
```

Pick a label that matches the card (`all-1g.5gb`, `all-2g.10gb`, `all-1g.10gb`, `all-disabled`, …). Workload: `nvidia.com/gpu: 1`.
