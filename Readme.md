# ENV
set BITCOIN_WALLET=bcrt1q09n4dh80gjsdjsr03kv8sxy0s298rz04m84wpc
set ALICE_WALLET=2N2KQ2xaCDywHoL7NDxSHjdLwULND1gkYpV
set BOB_WALLET=2MuD4wTf3ZyvXqoiQJag4yztDVQU8hmYXDu
set ALICE_NODE_PK=0362fcb3c97bcee62bb729ff501741ec729df7e58bc4fc670192c8dcf31b8b8c1a
set BOB_NODE_PK=023fc783f609c42436b544ef2751de59437f8c6c8cb0d4c964a4ba088d8724d59c

# Mine
docker exec bitcoind bitcoin-cli -datadir=/bitcoind generatetoaddress 6 %BITCOIN_WALLET%

# Balance
docker exec bitcoind bitcoin-cli -datadir=/bitcoind getbalance

# Send
docker exec bitcoind bitcoin-cli -datadir=/bitcoind sendtoaddress %ALICE_WALLET% 10
docker exec bitcoind bitcoin-cli -datadir=/bitcoind sendtoaddress %BOB_WALLET% 10

# LND Balance
docker exec Alice lncli --lnddir=/lnd -n regtest walletbalance
docker exec Bob lncli --lnddir=/lnd -n regtest walletbalance

# LND Peer
docker exec Bob lncli --lnddir=/lnd -n regtest getinfo
docker exec Alice lncli --lnddir=/lnd -n regtest connect %BOB_NODE_PK%@Bob
docker exec Alice lncli --lnddir=/lnd -n regtest listpeers

# Channel
docker exec Alice lncli --lnddir=/lnd -n regtest openchannel %BOB_NODE_PK% 1000000
docker exec bitcoind bitcoin-cli -datadir=/bitcoind generatetoaddress 6 %BITCOIN_WALLET%
docker exec Alice lncli --lnddir=/lnd -n regtest listchannels

# Payment
docker exec Bob lncli --lnddir=/lnd -n regtest addinvoice 1000
docker exec Alice lncli --lnddir=/lnd -n regtest payinvoice -f <lnbc...>
docker exec Alice lncli --lnddir=/lnd -n regtest listchannels

# Close
docker exec Alice lncli --lnddir=/lnd -n regtest closechannel --chan_point=<xxx:0>
docker exec bitcoind bitcoin-cli -datadir=/bitcoind generatetoaddress 6 %BITCOIN_WALLET%