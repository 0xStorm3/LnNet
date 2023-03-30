# ENV
set BITCOIN_WALLET=bcrt1qm5ufafmt7q2cgyqtfwlfp5k5hjyx64792x7afa
set ALICE_WALLET=2N2FVqDQCGhbuf5YtyYduTwNAdgC92ogj5W
set BOB_WALLET=2N5xFTKgXNJUFWv79eLsKQbvqVY112P7v38

docker exec Alice lncli --lnddir=/lnd -n regtest getinfo
docker exec Bob lncli --lnddir=/lnd -n regtest getinfo

set ALICE_NODE_PK=0239675e3d8be23ca2e8ab2d2639bd2da8bb1836948c46883777a3a3ea88c2e4a4
set BOB_NODE_PK=028508cec1f6a1c3e9565362b573e0be0aae14a69186482ed4c0cbcc3e4b0168de

# Mine
docker exec bitcoind bitcoin-cli -datadir=/bitcoind generatetoaddress 6 bcrt1qm5ufafmt7q2cgyqtfwlfp5k5hjyx64792x7afa

# Balance
docker exec bitcoind bitcoin-cli -datadir=/bitcoind getbalance

# Send
docker exec bitcoind bitcoin-cli -datadir=/bitcoind sendtoaddress 2N2FVqDQCGhbuf5YtyYduTwNAdgC92ogj5W 10

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