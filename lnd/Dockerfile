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
COPY lnd-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/lnd-entrypoint.sh

# LND RPC
EXPOSE 10009/tcp
# LND P2P
EXPOSE 9735/tcp

WORKDIR /lnd
ENTRYPOINT ["/usr/local/bin/lnd-entrypoint.sh"]