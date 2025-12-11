# ---------- 1. Build Stage ----------
FROM golang:1.24 AS builder

# Set environment variables
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

WORKDIR /app

# Only copy go.mod and go.sum first (layer caching)
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the project files
COPY * ./

# Build the binary
RUN go build -o app .

# ---------- 2. Runtime Stage ----------
FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/app .

EXPOSE 8080

CMD ["./app"]
