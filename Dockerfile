# Use stable Rust with edition 2021 (most recent stable edition)
FROM rust:1.82-alpine AS builder

# Install required dependencies
RUN apk add --no-cache musl-dev

WORKDIR /app

# Copy dependency files first for better caching
COPY Cargo.toml Cargo.lock ./

# Create a dummy main.rs to build dependencies
RUN mkdir src && echo "fn main() {}" > src/main.rs

# Build dependencies (this layer will be cached)
RUN cargo build --release && rm -rf src

# Copy actual source code
COPY src ./src

# Build the actual application
RUN cargo build --release --bin backend

# Runtime stage
FROM alpine:3.19

RUN apk add --no-cache ca-certificates
RUN addgroup -g 1001 -S appgroup && adduser -u 1001 -S appuser -G appgroup

# Copy the binary from builder stage
COPY --from=builder /app/target/release/backend /usr/local/bin/backend
RUN chmod +x /usr/local/bin/backend

USER appuser
EXPOSE 8080

CMD ["backend"]