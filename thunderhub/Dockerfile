ARG BASE_PATH=""
ARG NODE_ENV="production"
# ---------------
# Install Dependencies
# ---------------
FROM node:16.15.1-alpine as deps

# Download source
RUN apk add --update --no-cache git
RUN git clone https://github.com/apotdevin/thunderhub.git

# Install dependencies neccesary for node-gyp on node alpine
RUN apk add --update --no-cache \
  libc6-compat \
  python3 \
  make \
  g++

# Install app dependencies
RUN cd thunderhub && npm ci

# ---------------
# Build App
# ---------------
FROM deps as build

WORKDIR /thunderhub

# Set env variables
ENV BASE_PATH=${BASE_PATH}
ENV NODE_ENV=${NODE_ENV}
ENV NEXT_TELEMETRY_DISABLED=1

# Build the NestJS and NextJS application
RUN npm run build:nest
RUN npm run build:next

# Remove non production necessary modules
RUN npm prune --production

# ---------------
# Release App
# ---------------
FROM node:16.15.1-alpine as final

WORKDIR /thunderhub

# Set env variables
ENV BASE_PATH=${BASE_PATH}
ENV NODE_ENV=${NODE_ENV}
ENV NEXT_TELEMETRY_DISABLED=1

# Configuration
COPY files/.env.local .
COPY files/thubConfig.yaml .

COPY --from=build /thunderhub/package.json ./
COPY --from=build /thunderhub/node_modules/ ./node_modules

# Copy NextJS files
COPY --from=build /thunderhub/src/client/ ./src/client
#COPY --from=build /thunderhub/src/client/next.config.js ./src/client/
#COPY --from=build /thunderhub/src/client/.next/ ./src/client/.next
#COPY --from=build /thunderhub/src/client/pages/ ./src/client/pages
#COPY --from=build /thunderhub/src/client/config/ ./src/client/config

# Copy NestJS files
COPY --from=build /thunderhub/dist/ ./dist

EXPOSE 3000

COPY thunderhub-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/thunderhub-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/thunderhub-entrypoint.sh"]