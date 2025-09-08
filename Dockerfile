 FROM alpine/kubectl:1.34.0 AS builder
 CMD ["kubectl", "get nodes"]
