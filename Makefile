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
	@ssh-keyscan -H $$(pulumi stack output relayIp) >> ~/.ssh/known_hosts
	@ansible-playbook \
		--inventory $$(pulumi stack output relayIp),\
		--user=root \playbook.yml
