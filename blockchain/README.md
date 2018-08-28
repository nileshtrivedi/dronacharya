# Blockchain

This uses Go-Ethereum client to set up a new proof-of-authority blockchain network from scratch using the Clique consensus algorithm. In this, the validator nodes are trusted and therefore, we can achieve better throughput and legal compliance at lower cost.

## Initialize the network:

`geth --datadir=$HOME/.poa init proof_of_authority.json`

## Connect to the network:

`geth --networkid=246 --datadir=$HOME/.poa --cache=512 --bootnodes=enode://bcf6cd04ffdf4cacac1020a4627d1e528ae574edf8bf5e77301052673f8452da40fad86c8b02e7e088b8406d7e900b3d5f929424c5049d80598aa22d358e2f63@95.216.173.40:30305`

## See network status dashboard:

http://95.216.173.40:8080/