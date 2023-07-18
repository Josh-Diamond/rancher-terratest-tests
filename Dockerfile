FROM golang:1.19

USER root
RUN mkdir -p /.cache && chmod -R 777 /.cache

# Create the Go module cache directory
RUN mkdir -p $GOPATH/pkg/mod && chmod -R 777 $GOPATH/pkg/mod

RUN chown -R root:root $GOPATH/pkg/mod && chmod -R g+rwx $GOPATH/pkg/mod

# Configure Go
# ENV GOPATH /root/go
# ENV PATH ${PATH}:/root/go/bin

ENV WORKSPACE ${GOPATH}/src/github.com/Josh-Diamond/rancher-terratest-tests

WORKDIR $WORKSPACE/terratest

COPY [".", "$WORKSPACE"]

RUN go mod download && \
    go install gotest.tools/gotestsum@latest

COPY . .

# RUN chmod -R 777 ${WORKSPACE}/modules/cluster

# Configure Terraform
ARG TERRAFORM_VERSION=0.13.7
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && apt-get update && apt-get install unzip &&  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && chmod u+x terraform && mv terraform /usr/bin/terraform

# Copy the config file into the container
ARG CONFIG_FILE
COPY ${CONFIG_FILE} /config.yml


# necessary to run if statements using [[ ]]
SHELL ["/bin/bash", "-c"] 
