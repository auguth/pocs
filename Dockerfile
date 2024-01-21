# Use the official Rust image as a base
FROM rust:latest

# Create a new empty shell project
RUN USER=root cargo new --bin pocs
WORKDIR /pocs

# Copy the Cargo.toml and Cargo.lock files and source code
COPY ./Cargo.toml ./Cargo.toml
COPY ./Cargo.lock ./Cargo.lock
COPY ./src ./src

# Build the project to cache dependencies
RUN cargo build --release

# RUN cargo build --release -p my-package-name

# Remove the build artifacts from the previous step
RUN rm src/*.rs
RUN rm ./target/release/deps/pocs*

# Now copy the actual source code
COPY . .

# Build again. This time it'll be a bit quicker because the dependencies are cached
RUN cargo build --release

# Expose the default p2p port, rpc port and ws port
EXPOSE 30333 9933 9944

# Run pocs tests
RUN cargo test pocs

# Run the Substrate node
CMD ["./target/release/pocs"]
