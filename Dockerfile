# Use the official Rust image as a base
FROM rust:latest

# Create a new empty shell project named 'pocs'
RUN USER=root cargo new --bin pocs
WORKDIR /pocs

# Install required packages
RUN apt-get update && \
    apt-get install -y \
    clang \
    curl \
    libssl-dev \
    protobuf-compiler

# Install Rust nightly version (as of 2023-12-21)
RUN rustup install nightly-2023-12-21

# Configure the Rust toolchain for wasm32-unknown-unknown on nightly-2023-12-21
RUN rustup target add wasm32-unknown-unknown --toolchain nightly-2023-12-21

# Override the default Rust version to nightly-2023-12-21 for this project
RUN rustup override set nightly-2023-12-21 

# Copy the actual source code into the container
COPY . .

# Build the project in release mode  
RUN cargo build --release

# Expose the specified ports
EXPOSE 9944 9933 30333

# Run the Substrate node in development mode
CMD ["./target/release/pocs", "--dev", "--rpc-cors=all"]