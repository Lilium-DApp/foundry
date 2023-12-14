# LOADING ENV FILE
-include .env

.PHONY: env deploy cartesi device

# DEFAULT VARIABLES	
START_LOG = @echo "==================== START OF LOG ===================="
END_LOG = @echo "==================== END OF LOG ======================"

define deploy_forest_reserve
	$(START_LOG)
	@forge script script/DeployForestReserve.s.sol --rpc-url $(RPC_URL) --broadcast --verify --etherscan-api-key $(API_KEY) -vvvvv
	$(END_LOG)
endef

define set_cartesi
	$(START_LOG)
	@cast send $1 "setCartesiDapp(address)" $2 --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY)
	$(END_LOG)
endef

define set_device
	$(START_LOG)
	@cast send $1 "addDevice(address)" $2 --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY)
	$(END_LOG)
endef

env: .env.tmpl
	cp .env.tmpl .env

deploy:
	@echo "Deploying forest reserve..."
	@$(call deploy_forest_reserve)

cartesi:
	@echo "Setting cartesi dapp..."
	@$(call set_cartesi,$(forest_reserve),$(dapp))

device:
	@echo "Setting device..."
	@$(call set_device,$(forest_reserve),$(device))
