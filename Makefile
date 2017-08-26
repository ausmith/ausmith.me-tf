.DEFAULT_GOAL := help
.PHONY: help test-plan prod-plan test-apply prod-apply tf-fmt

TERRAFORM_BIN := $(shell which terraform)

help:
	@echo "Builds ausmith.me site (test or prod)"
	@echo ""
	@echo "Targets:"
	@echo "  test-plan       Runs tf plan against test"
	@echo "  test-apply      Runs tf apply against test"
	@echo "  test-teardown   Runs tf destroy against test"
	@echo "  prod-plan       Runs tf plan against prod"
	@echo "  prod-apply      Runs tf apply against prod"
	@echo "  check-config    Runs tf formatting and validation across files"
	@echo "	                 (assumes remote_state.tf is created)"

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

tf-destroy:
	$(TERRAFORM_BIN) destroy

# Meaningful targets to the user
test-plan: clean-tf-remote-state init-test-remote-state tf-validate tf-init tf-plan

test-apply: test-plan tf-apply

test-teardown: clean-tf-remote-state init-test-remote-state tf-destroy

prod-plan: clean-tf-remote-state init-prod-remote-state tf-validate tf-init tf-plan

prod-apply: prod-plan tf-apply

check-config: tf-fmt tf-validate
