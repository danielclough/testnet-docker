# docker-compose Blackcoin Testnet

Commands are somewhat self documented.

## Setup

`setup.sh` (requires sudo)

1. Check for `docker-compose` and install if needed
1. Create network with 5 nodes

Running in daemon mode will cause user to lose access to blackmore cookies.
Consider running with `screen`.

## Initialization

While network is active run the `init.sh` script (only once).

`init.sh` (takes ~10 hours)

- initializes network with a roughly equal amount of BLK per node.
- you will know that it has finished properly when it returns 5 equal hashes.

## Tests

`test-blocktime.sh`

- checks blocktime is less than 70 seconds per block

`test-multisig.sh`

- tests multisig creation and spending
