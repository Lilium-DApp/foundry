# LOADING ENV FILE
-include .env

.PHONY: system env

# DEFAULT VARIABLES	
START_LOG = @echo "==================== START OF LOG ===================="
END_LOG = @echo "==================== END OF LOG ======================"


ifeq ($(CONFIG),--network sepolia)
	RPC_URL := $(SEPOLIA_RPC_URL)
	DEPLOY_NETWORK_ARGS := script/DeployForestReserve.s.sol --rpc-url $(SEPOLIA_RPC_URL) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvvv
endif

define system_rollout
	$(START_LOG)
	@forge script $(DEPLOY_NETWORK_ARGS) -vvvvv
	$(END_LOG)
endef

env: .env.tmpl
	cp .env.tmpl .env

system:
	@echo "System Rollout..."
	@$(system_rollout)