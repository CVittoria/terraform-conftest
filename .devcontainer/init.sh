#!/bin/bash

TERRAFORM_DOCS_VERSION="0.16.0"
TERRAFORM_LS_VERSION="0.29.2"
CONFTEST_VERSION="0.34.0"
OPA_VERSION="0.44.0"

cd /

go install github.com/terraform-docs/terraform-docs@v${TERRAFORM_DOCS_VERSION}

ln -s /go/bin/* /usr/local/go/bin

apt-get update && \
    apt-get install -y \
        make && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*

wget https://releases.hashicorp.com/terraform-ls/${TERRAFORM_LS_VERSION}/terraform-ls_${TERRAFORM_LS_VERSION}_linux_amd64.zip \
      -O ./terraform-ls.zip && \
    unzip ./terraform-ls.zip && \
    rm -f ./terraform-ls.zip && \
    chmod +x ./terraform-ls && \
    mv ./terraform-ls /usr/local/bin/terraform-ls

wget https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz \
      -O ./conftest.tar.gz && \
    tar xzf conftest.tar.gz && \
    mv conftest /usr/local/bin && \
    rm -f conftest.tar.gz && \
    wget https://openpolicyagent.org/downloads/v${OPA_VERSION}/opa_linux_amd64_static \
      -O opa && \
    chmod 755 ./opa && \
    mv opa /usr/local/bin