#!/bin/bash
set -Eeuo pipefail

echo Waiting for bitcoind to start...
until curl --silent --user regtest:regtest --data-binary '{"jsonrpc": "1.0", "id": "lnd-node", "method": "getblockchaininfo", "params": []}' -H 'content-type: text/plain;' http://bitcoind:18443/ | jq -e ".result.blocks > 0" > /dev/null 2>&1
do
	echo -n "."
	sleep 1
done

echo Starting lnd...
lnd --lnddir=/lnd --noseedbackup > /dev/null &

until lncli --lnddir=/lnd -n regtest getinfo > /dev/null 2>&1
do
	sleep 1
done
echo "Startup complete"
# echo "Funding lnd wallet"
# source /usr/local/bin/fund-lnd.sh
address=$(lncli --lnddir=/lnd --network regtest newaddress np2wkh | jq .address)
echo "================================================"
echo "LND Wallet address: " ${address}
echo "================================================"

# exec "$@"
tail -f /lnd/logs/bitcoin/regtest/lnd.log
