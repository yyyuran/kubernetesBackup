# Use the official Alpine Linux base image
FROM alpine:latest

# Install necessary packages for downloading and extracting kubectl
RUN apk add --no-cache curl tar gzip

# Define the Kubernetes version to install (optional, can be passed as a build argument)
ARG KUBECTL_VERSION="1.29.0" 

# Download, extract, and install kubectl
RUN curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl

# Set the entrypoint to kubectl, allowing commands to be passed as arguments
ENTRYPOINT ["kubectl"]
CMD ["kubectl,"--help"]