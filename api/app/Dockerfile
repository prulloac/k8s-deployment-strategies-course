# Use the official Golang image as a builder
FROM golang:latest AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy the source code into the container
COPY main.go .
COPY go.mod .

# Build the Go app
# CGO_ENABLED=0 is needed for a static build suitable for scratch/alpine
# -ldflags "-s -w" strips debugging information and symbols to reduce binary size
RUN CGO_ENABLED=0 go build -ldflags "-s -w" -o /app/server .

# Start a new stage from scratch (or alpine for basic tools like shell)
FROM alpine:latest
ARG TEXT="Hello from Docker!"
ARG VERSION="v1"

WORKDIR /app

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/server .

# Expose port 8080 to the outside world
EXPOSE 8080

# Set the default landing text, can be overridden
ENV LANDING_TEXT=${TEXT}
ENV VERSION=${VERSION}

# Command to run the executable
ENTRYPOINT ["/app/server"]
