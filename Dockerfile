FROM golang:1.19

RUN mkdir -p /.cache && chmod -R 777 /.cache

# Configure Go
ENV GOPATH /root/go
ENV PATH ${PATH}:/root/go/bin

ENV WORKSPACE ${GOPATH}/src/github.com/Josh-Diamond/rancher-terratest-tests

WORKDIR $WORKSPACE/terratest/cluster

COPY [".", "$WORKSPACE"]

RUN go mod download && \
    go install gotest.tools/gotestsum@latest

# Configure Terraform
ARG TERRAFORM_VERSION=0.13.7
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && apt-get update && apt-get install unzip &&  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && chmod u+x terraform && mv terraform /usr/bin/terraform

# Copy the config file into the container
ARG CONFIG_FILE
COPY ${CONFIG_FILE} /config.yml


# necessary to run if statements using [[ ]]
SHELL ["/bin/bash", "-c"] 
