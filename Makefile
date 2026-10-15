SHELL := /bin/sh

RENDERER := machine-api/render_gpu_machineset.py
GPU_REPLICAS ?= 1
GPU_SOURCE_MACHINESET ?=

NVIDIA_L4_INSTANCE_TYPE ?= g6.8xlarge
NVIDIA_T4_INSTANCE_TYPE ?= g4dn.xlarge
NVIDIA_A10G_INSTANCE_TYPE ?= g5.2xlarge

.PHONY: help add-nvidia-l4 add-nvidia-t4 add-nvidia-a10g

help: ## List targets
	@awk 'BEGIN {FS = ":.*## "}; /^[a-zA-Z0-9_.-]+:.*## / { printf "  %-18s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

# $(1) instance-type  $(2) machineset suffix  $(3) node-label list
define add-pool
	@python3 "$(RENDERER)" \
	  --instance-type="$(1)" \
	  --name-suffix="$(2)" \
	  $(foreach label,$(3),--node-label="$(label)") \
	  --replicas="$(GPU_REPLICAS)" \
	  $(if $(GPU_SOURCE_MACHINESET),--source-machineset="$(GPU_SOURCE_MACHINESET)") \
	  --apply
endef

add-nvidia-l4: ## NVIDIA L4   (g6.8xlarge)  → *-gpu-nvidia-l4
	$(call add-pool,$(NVIDIA_L4_INSTANCE_TYPE),gpu-nvidia-l4,node-role.kubernetes.io/gpu node-role.kubernetes.io/nvidia-l4)

add-nvidia-t4: ## NVIDIA T4   (g4dn.xlarge) → *-gpu-nvidia-t4
	$(call add-pool,$(NVIDIA_T4_INSTANCE_TYPE),gpu-nvidia-t4,node-role.kubernetes.io/gpu node-role.kubernetes.io/nvidia-t4)

add-nvidia-a10g: ## NVIDIA A10G (g5.2xlarge)  → *-gpu-nvidia-a10g
	$(call add-pool,$(NVIDIA_A10G_INSTANCE_TYPE),gpu-nvidia-a10g,node-role.kubernetes.io/gpu node-role.kubernetes.io/nvidia-a10g)
