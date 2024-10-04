FROM ghcr.io/foundry-rs/foundry

WORKDIR /app

# Build and test the source code
COPY . .
RUN forge build

EXPOSE 8545
ENTRYPOINT ["anvil", "--gas-limit", "1000000000000", "--code-size-limit", "1000000000", "--balance", "1000000000", "--host", "0.0.0.0"]
