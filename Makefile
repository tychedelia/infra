.PHONY: build
build:
	@echo "destroy existing environment..."
	@$(MAKE) pulumi-destroy
	@echo "create environment..."
	@$(MAKE) pulumi-up
	@echo "process relay server..."
	@$(MAKE) ansible 

.PHONY: pulumi-up
pulumi-up:
	@pulumi up --yes

.PHONY: pulumi-destroy
pulumi-destroy:
	@pulumi destroy --yes

.PHONY: ansible
ansible:
	@ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook \
		--inventory $$(pulumi stack output relayIp),\
		--user=root \playbook.yml
