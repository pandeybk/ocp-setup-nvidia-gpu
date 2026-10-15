# NVIDIA DCGM dashboard

Official NVIDIA Grafana dashboard in OpenShift **Observe → Dashboards**. ClusterPolicy already enables DCGM exporter + ServiceMonitor.

```bash
oc apply -k use-cases/dashboard
oc -n openshift-config-managed get cm nvidia-dcgm-exporter-dashboard --show-labels
```

Console: Administrator → Observe → Dashboards → **NVIDIA DCGM Exporter Dashboard**.

JSON source: https://github.com/NVIDIA/dcgm-exporter/blob/main/grafana/dcgm-exporter-dashboard.json
