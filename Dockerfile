# Build stage
FROM rust:latest as builder

WORKDIR /app

# Copy manifest files
COPY Cargo.toml Cargo.lock ./

# Copy source code
COPY src ./src

# Build the application in release mode
RUN cargo build --release

# Runtime stage using distroless
FROM gcr.io/distroless/cc-debian12

# Copy the binary from builder stage
COPY --from=builder /app/target/release/backend /usr/local/bin/backend

# Expose port 8080
EXPOSE 8080

# Set the startup command
CMD ["backend"]