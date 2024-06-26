# To load the variables in the .env file
source .env

echo $ETHERSCAN_API_KEY
# To deploy and verify our contract on bsc chain
forge create --chain bsc --rpc-url $RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY --verify src/TokenTimelockFactory.sol:TokenTimelockFactory
