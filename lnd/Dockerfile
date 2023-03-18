ARG OS=ubuntu
ARG OS_VER=focal

# Define base images with ARG versions
FROM ${OS}:${OS_VER} as os

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -qq && apt-get install -yqq \
		curl unzip jq bash-completion

# OS image with command-line utilities
FROM os AS lnd-install

# Install LND
ARG LND_VER=v0.15.5-beta
ENV LND_VER=${LND_VER}

RUN cd /tmp && \
	curl -# -sLO https://github.com/lightningnetwork/lnd/releases/download/v0.15.5-beta/lnd-linux-amd64-${LND_VER}.tar.gz

RUN tar -xvf /tmp/lnd-linux-amd64-${LND_VER}.tar.gz -C / && \
	cd lnd-linux-amd64-${LND_VER} && \
	install -vD * /usr/bin && \
	cd /tmp && \
	rm lnd-linux-amd64-${LND_VER}.tar.gz && \
	rm -rf lnd-linux-amd64-${LND_VER}

COPY lnd /lnd
RUN ln -s /lnd /root/.lnd
# COPY fund-lnd.sh /usr/local/bin
# RUN chmod +x /usr/local/bin/fund-lnd.sh
# COPY bashrc /root/.bashrc
COPY lnd-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/lnd-entrypoint.sh
# COPY logtail.sh /usr/local/bin
# RUN chmod +x /usr/local/bin/logtail.sh
# COPY wait-for-bitcoind.sh /usr/local/bin
# RUN chmod +x /usr/local/bin/wait-for-bitcoind.sh
# COPY cli /usr/local/bin
# RUN chmod +x /usr/local/bin/cli

# LND RPC
EXPOSE 10009/tcp
# LND P2P
EXPOSE 9735/tcp

WORKDIR /lnd
ENTRYPOINT ["/usr/local/bin/lnd-entrypoint.sh"]

# Show logs from beginning and keep following
# CMD ["/usr/local/bin/logtail.sh"]