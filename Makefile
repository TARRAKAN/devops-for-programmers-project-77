TERRAFORM_DIRECTORY_PATH = ./terraform
ANSIBLE_DIRECTORY_PATH = ./ansible

get_tf_vars_from_vault:
	ansible-playbook get_tf_vars_from_vault_playbook.yml --ask-vault-password

prepare_infrostructure:
	make -C $(TERRAFORM_DIRECTORY_PATH) init
	make -C $(TERRAFORM_DIRECTORY_PATH) apply

deploy_redmine:
	make -C $(ANSIBLE_DIRECTORY_PATH) prepare
	make -C $(ANSIBLE_DIRECTORY_PATH) deploy
