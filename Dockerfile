# # Start with a base Go image
# FROM golang:1.21-alpine as builder

# # Set the Current Working Directory inside the container to /backEnd
# WORKDIR /backEnd

# # Copy go mod and sum files
# COPY go.mod go.sum ./

# # Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
# RUN go mod tidy

# # Copy the entire project
# COPY . .

# # Build the Go app (main.go is the entry point)
# RUN go build -o api ./cmd/api/main.go

# # Start a new stage from a smaller image to run the Go application
# FROM alpine:latest  

# # Install required dependencies for running the Go binary (like libc for some Go modules)
# RUN apk --no-cache add ca-certificates

# # Set the Current Working Directory inside the container to /backEnd
# WORKDIR /backEnd

# # Copy the pre-built binary file from the build stage
# COPY --from=builder /backEnd/api .

# # Expose the port your app will run on
# EXPOSE 8080

# # Command to run the executable
# CMD ["./api"]




# Stage 1: Build the Go application
FROM golang:1.21-alpine as builder

# Set the working directory in the container
WORKDIR /app

# Copy go.mod and go.sum files and download dependencies
COPY go.mod go.sum ./
RUN go mod tidy

# Copy the entire project
COPY . .

# Build the Go application
RUN go build -o api ./cmd/api/

# Stage 2: Create the final image
FROM alpine:latest

# Set the working directory in the container
WORKDIR /root/

# Install bash and certificates
RUN apk --no-cache add bash ca-certificates file

# Copy the Go application from the builder stage
COPY --from=builder /app/api .

# Copy the wait-for-it.sh script and make it executable
# COPY wait-for-it.sh /wait-for-it.sh
# RUN chmod +x /wait-for-it.sh

# Expose the necessary port (change the port if needed)
EXPOSE 8080

# Command to run the Go application
# CMD ["/wait-for-it.sh", "postgres:5432", "--", "./api"]
CMD ["./api"]

