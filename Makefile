TOP_DIR = ../..
DEPLOY_RUNTIME ?= /kb/runtime
TARGET ?= /kb/deployment
include $(TOP_DIR)/tools/Makefile.common

AWE_HOST       = localhost
AWE_API_PORT   = 7080
AWE_SERVER_API = $(AWE_HOST):$(AWE_PORT)

TPAGE_ARGS = --define kb_top=$(TARGET) --define kb_runtime=$(DEPLOY_RUNTIME) --define awe_host=$($AWE_HOST) --define awe_api_port=$AWE_API_PORT -define awe_server_api=$(AWE_SERVER_API)


default: build-scripts
	@echo "running default make"

test: test-client test-scripts test-service
	@echo "running client and script tests"

test-client:
	@echo "test-client not implemented"

test-scripts:
	@echo "test-scripts not implemented"

test-service:
	@echo "test-service not implemented"


deploy: deploy-client deploy-service

# depricated target
deploy-all: deploy-client deploy-service

deploy-client: deploy-scripts deploy-docs

deploy-service: deploy-cfg
	echo "nothing to do for deploy-service target"

# how to standardize and automate CLI documentation.
deploy-docs:
	@echo "deploy docs not implemented"

build-scripts: TEMPLATES = $(wildcard templates/*.tt)
build-scripts:
	for src in $(TEMPLATES) ; do       \
		basefile=`basename $$src`; \
		base=`basename $$src .tt`; \
		$(TPAGE) $(TPAGE_ARGS) $$src > scripts/awe-$$base ; \
	done ;

include $(TOP_DIR)/tools/Makefile.common.rules
