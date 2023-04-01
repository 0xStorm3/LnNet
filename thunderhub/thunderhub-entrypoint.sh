#!/bin/sh
set -Eeuo pipefail

until ls -l /lnd/tls.cert > /dev/null 2>&1
do
	sleep 1
    echo "Waiting for LND"
done

cd /thunderhub
npm run start:prod