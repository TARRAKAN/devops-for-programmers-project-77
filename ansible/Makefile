INVENTORY_FILE = inventory.ini
GENERAL_ANSOBLE_PLAYBOOK_FLAGS = -i $(INVENTORY_FILE) --vault-password-file=webservers_vault_password

install_roles:
	ansible-galaxy install -r requirements.yml

prepare: install_roles
	ansible-playbook preparation_playbook.yml $(GENERAL_ANSOBLE_PLAYBOOK_FLAGS)

deploy:
	ansible-playbook playbook.yml $(GENERAL_ANSOBLE_PLAYBOOK_FLAGS)

stop:
	ansible-playbook stopping_playbook.yml $(GENERAL_ANSOBLE_PLAYBOOK_FLAGS)
