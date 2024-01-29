# Use the official Ubuntu image as a base
FROM ubuntu:latest

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    clang \
    curl \
    libssl-dev \
    protobuf-compiler 

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Add Rust binaries to the PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Create a new empty shell project named 'pocs'
RUN USER=root cargo new --bin pocs
WORKDIR /pocs

# Update to stable version
RUN rustup default stable && \
    rustup update

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

# Run the Substrate node in development mode . STRICTLY USED FOR DEVELOPMENT PURPOSE ONLY
CMD ["./target/release/pocs", "--dev", "--rpc-external", "--rpc-cors=Unsafe"]
