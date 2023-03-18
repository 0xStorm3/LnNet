#!/bin/bash
set -Eeuo pipefail


# Start bitcoind
echo "Starting bitcoind..."
bitcoind -datadir=/bitcoind -daemon

# Wait for bitcoind startup
echo -n "Waiting for bitcoind to start"
until bitcoin-cli -datadir=/bitcoind -rpcwait getblockchaininfo  > /dev/null 2>&1
do
	echo -n "."
	sleep 1
done
echo
echo "bitcoind started"


bitcoin-cli -datadir=/bitcoind createwallet regtest > /dev/null
address=`bitcoin-cli -datadir=/bitcoind getnewaddress`
echo "================================================"
# echo "Imported demo private key"
echo "Bitcoin address: " ${address}
# echo "Private key: " ${privkey}
echo "================================================"

bitcoin-cli -datadir=/bitcoind generatetoaddress 101 $address
echo "Balance:" `bitcoin-cli -datadir=/bitcoind getbalance`

tail -f /bitcoind/regtest/debug.log
