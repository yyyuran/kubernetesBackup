# Use the official Alpine Linux base image
FROM alpine:latest

RUN apk update && apk add bash

# Install necessary packages for downloading and extracting kubectl
RUN apk add --no-cache curl tar gzip

# Define the Kubernetes version to install (optional, can be passed as a build argument)
ARG KUBECTL_VERSION="1.29.0" 

# Download, extract, and install kubectl
RUN curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl

# Set the entrypoint to kubectl, allowing commands to be passed as arguments
#ENTRYPOINT ["kubectl"]
#    - kubectl config set-context default --cluster=local-cluster --namespace=default --user=sa-runner;
#    - kubectl config use-context default;
#CMD ["kubectl", "config", "set-context","--cluster=local-cluster","--namespace=default","--user=sa-runner"]
#CMD ["kubectl", "get", "nodes"]
#CMD ["kubectl", "get", "namespaces"]


CMD ["sh", "-c", "dd=$(date +'%F_%H-%M-%S') && echo $dd && kubectl -n site exec --stdin --tty site-bitrix-app-mysql-0 -- /bin/bash -c  'mysqldump  -u root --password=iOPt6ZXGtn7zEjxsub3MoDLwAa51EQP8 --routines bitrix-app > /tmp/btrx_'$dd'.sql' && kubectl cp site/site-bitrix-app-mysql-0:/tmp/btrx_$dd.sql /nfs-data/btrx_$dd.sql && ls -l /nfs-data"]
