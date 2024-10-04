FROM node:20.8.1-alpine3.18 AS node
FROM ghcr.io/foundry-rs/foundry

COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

WORKDIR /app

# Build and test the source code
COPY . .
RUN forge build
RUN npm install

EXPOSE 8545
ENTRYPOINT ["npx", "hardhat", "node"]
