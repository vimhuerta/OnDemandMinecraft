#########################################################
# Makefile as entrypoint 
#########################################################

# Variables
QUIET=@


.PHONY:	python_venv minecraft

# Creates python virtual environment
python_venv:
	$(QUIET)python3 -m venv minecraft_venv
	$(QUIET)source ./minecraft_venv/bin/activate
	$(QUIET)pip install -r requirements.txt


# Calls ansible playbook
minecraft:
	$(QUIET)ansible-playbook -i localhost -c "local" create_minecraft_server.yaml