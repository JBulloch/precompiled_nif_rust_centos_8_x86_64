# Dockerfile for building pre-compiled NIFs
# Uses the sandbox container as base to ensure glibc compatibility
#
# Build args:
#   SANDBOX_IMAGE - The sandbox container image to use as base (required)
#
# Usage:
#   docker build --build-arg SANDBOX_IMAGE=your-sandbox-image:tag -t nif-builder .
#   docker run --rm -v $(pwd):/app -w /app nif-builder

ARG SANDBOX_IMAGE
FROM ${SANDBOX_IMAGE:?SANDBOX_IMAGE build argument is required}

# Install Rust toolchain
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Set Erlang and Elixir versions for reference
ENV ERLANG_VERSION=27.3.4
ENV ELIXIR_VERSION=1.18.4-otp-27

# Set working directory
WORKDIR /app

# Copy the project files
COPY . .

# Default command - build the NIF
CMD ["sh", "-c", "cd native/explorer && cargo build --release"]
