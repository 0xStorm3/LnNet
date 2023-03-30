#!/bin/bash
set -Eeuo pipefail

until ls -l /lnd/tls.cert > /dev/null 2>&1
do
	sleep 1
    echo "Waiting for LND"
done

LND_GRPC_ENDPOINT=${LND_GRPC_ENDPOINT} poetry run lnbits