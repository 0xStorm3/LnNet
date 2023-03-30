FROM python:3.10-slim

RUN apt-get clean
RUN apt-get update
RUN apt-get install -y curl pkg-config build-essential git

RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

RUN git clone https://github.com/WaldenSats/lnbits.git

WORKDIR /lnbits

COPY files .

COPY lnbits-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/lnbits-entrypoint.sh

RUN mkdir data

RUN poetry config virtualenvs.create false
RUN poetry install --only main

EXPOSE 5000

ENTRYPOINT ["/usr/local/bin/lnbits-entrypoint.sh"]

