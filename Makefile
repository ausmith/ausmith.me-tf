.DEFAULT_GOAL := help
.PHONY: help plan apply tf-fmt check-config

TERRAFORM_BIN := $(shell which terraform)

help:
	@echo "Builds ausmith.me site"
	@echo ""
	@echo "Targets:"
	@echo "  plan            Runs tf plan against prod"
	@echo "  apply           Runs tf apply against prod"
	@echo "  check-config    Runs tf formatting and validation across files"
	@echo "	                 (assumes remote_state.tf is created)"

# remote_state.tf setup
init-prod-remote-state:
	./generate_remote_state_tf.sh prod

# Clean remote_state.tf
clean-tf-remote-state:
	rm -f remote_state.tf

# TF commands
tf-init:
	$(TERRAFORM_BIN) init

tf-validate:
	$(TERRAFORM_BIN) validate

tf-plan:
	$(TERRAFORM_BIN) plan

tf-apply:
	$(TERRAFORM_BIN) apply

tf-fmt:
	$(TERRAFORM_BIN) fmt

tf-destroy:
	$(TERRAFORM_BIN) destroy

# Meaningful targets to the user
plan: clean-tf-remote-state init-prod-remote-state tf-validate tf-init tf-plan

apply: plan tf-apply

check-config: tf-fmt tf-validate
