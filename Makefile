TF_ADD =

# get OS and set tf-bin folder
ifeq ($(OS),Windows_NT)
	detected_OS := Windows
else
	detected_OS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')
endif

ifeq ($(detected_OS),Windows)
	TF-BIN ?= tf-bin/winx64
endif
ifeq ($(detected_OS),Darwin)
	TF-BIN ?= tf-bin/darwin
endif
ifeq ($(detected_OS),Linux)
	TF-BIN ?= tf-bin/liniux-x64
endif

ifdef target
	TF_ADD =  -target="$(target)"
endif

ifdef lockid
	TF_ADD = $(lockid)
endif


tf-validate: ## validates terraform templates
	$(TF-BIN)/terraform validate

tf-first-init: ## initial init, creates s3 bucket & dynamodb for remote state file
	pushd modules/backend ; ../../$(TF-BIN)/terraform init ; popd
	pushd modules/backend ; ../../$(TF-BIN)/terraform apply ; popd
	$(TF-BIN)/terraform init

tf-init: ## updates modules, reinits state
	$(TF-BIN)/terraform init

tf-plan: ## terraform plan
	$(TF-BIN)/terraform plan $(TF_ADD)

tf-apply: ## terraform apply
	$(TF-BIN)/terraform apply $(TF_ADD)

tf-destroy: ## terraform destroy
	$(TF-BIN)/terraform destroy $(TF_ADD)

tf-output: ## terraform output
	$(TF-BIN)/terraform output $(TF_ADD)

tf-unlock: ## force-unlock
	$(TF-BIN)/terraform force-unlock $(TF_ADD)

tf-version: ## terraform version
	$(TF-BIN)/terraform version

tf-refresh: ## terraform refresh
	$(TF-BIN)/terraform refresh
