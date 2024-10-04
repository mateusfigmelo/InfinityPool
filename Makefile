all:

init-modules:
	git submodule update --recursive --init


refresh-modules:
	git pull --recurse-submodules

install:
	curl -L https://foundry.paradigm.xyz | bash
	bash -l -c foundryup # it needs to source ~/.bashrc after the command above
	npm ci

periphery-tests:
	FORKING=true npx hardhat test test/unit/hardhat/periphery/forking/***
	npx hardhat test test/unit/hardhat/periphery/nonforking/***

tests:
	forge test

hardhat-start:
	touch /tmp/hardhat-node.log
	nohup npx hardhat node > /tmp/hardhat-node.log 2>&1 &

hardhat-stop:
	fuser -k -9 /tmp/hardhat-node.log

hardhat-deploy:
	@anvil node scripts/hardhat/deploy.js -n localhost -t TokenA:6 -t TokenB:8 -- TokenA:TokenB:15

# https://stackoverflow.com/a/77171590/24204480
anvil-start:
	nohup anvil --prune-history --order fifo --code-size-limit 4294967296 \
		-m "test test test test test test test test test test test junk" \
		--gas-limit 100000000000 \
		--host 0.0.0.0 --port 8545 \
		> /tmp/anvil-node.log 2>&1 &

anvil-stop:
	-fuser -k -9 /tmp/anvil-node.log

anvil-deploy:
	@node scripts/hardhat/deploy.js -n anvil -t TokenA:6 -t TokenB:8 -- TokenA:TokenB:15

anvil-deploy-test:
	@node scripts/hardhat/deploy.js -T -n anvil -t TokenA:6 -t TokenB:8 -- TokenA:TokenB:15
