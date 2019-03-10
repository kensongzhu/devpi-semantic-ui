# Globals
THEME_NAME = semantic_ui
THEME_DIR = ${PWD}/devpi_$(THEME_NAME)
SERVER_DIR = ${PWD}/tmp/server
CLIENT_DIR = ${PWD}/tmp/client
HOST = 127.0.0.1
PORT = 3141

init:
	pipenv install --dev
	devpi-server --init --serverdir $(SERVER_DIR)

pre-serve:
	devpi-server --start --host $(HOST) --port $(PORT) --serverdir $(SERVER_DIR) --theme $(THEME_DIR)

post-serve:
	devpi use http://$(HOST):$(PORT) --clientdir $(CLIENT_DIR)
	devpi user -c developer password=developer --clientdir $(CLIENT_DIR)
	devpi login developer --password=developer --clientdir $(CLIENT_DIR)
	devpi index -c $(THEME_NAME) bases=root/pypi --clientdir $(CLIENT_DIR)

pre-stop:
	devpi user --delete -y developer --clientdir ${PWD}/tmp/client

post-stop:
	devpi-server --stop --host $(HOST) --port $(PORT) --serverdir $(SERVER_DIR)

serve:
	make pre-serve
	make post-serve

stop:
	make pre-stop
	make post-stop

clean-build:
	rm -fr build dist .egg *.egg-info

clean-pyc:
	find . -name '*.pyc' -delete
