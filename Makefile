.DEFAULT_GOAL := help
.PHONY: help test-plan prod-plan test-apply prod-apply tf-fmt

TERRAFORM_BIN := $(shell which terraform)

help:
	@echo "Builds ausmith.me site (test or prod)"
	@echo ""
	@echo "Targets:"
	@echo "  test-plan       Runs tf plan against test"
	@echo "  test-apply      Runs tf apply against test"
	@echo "  prod-plan       Runs tf plan against prod"
	@echo "  prod-apply      Runs tf apply against prod"
	@echo "  tf-fmt          Runs tf formatting across files"

# remote_state.tf setup
init-test-remote-state:
	./generate_remote_state_tf.sh test

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

# Meaningful targets to the user
test-plan: clean-tf-remote-state init-test-remote-state tf-validate tf-init tf-plan

test-apply: test-plan tf-apply

prod-plan: clean-tf-remote-state init-prod-remote-state tf-validate tf-init tf-plan

prod-apply: prod-plan tf-apply
