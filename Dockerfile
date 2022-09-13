ARG GO_VERSION="1.18.5"

FROM golang:${GO_VERSION}-alpine

ARG TERRAFORM_VERSION="1.1.9"
ARG TERRAGRUNT_VERSION="0.38.0"
ARG TERRAFORM_DOCS_VERSION="0.16.0"
ARG CONFTEST_VERSION="0.34.0"
ARG OPA_VERSION="0.44.0"

WORKDIR /

RUN apk add --no-cache \
        bash \
        make \
        jq \
        git \
        build-base

# Install terraform & terragrunt
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
      -O ./terraform.zip && \
    unzip ./terraform.zip && \
    rm -f ./terraform.zip && \
    chmod +x ./terraform && \
    mv ./terraform /usr/local/bin/terraform && \
    wget https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 \
      -O /usr/local/bin/terragrunt && \
    chmod +x /usr/local/bin/terragrunt

# Install terraform-docs
RUN go install github.com/terraform-docs/terraform-docs@v${TERRAFORM_DOCS_VERSION}

# Install conftest + opa
RUN wget https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz \
      -O ./conftest.tar.gz && \
    tar xzf conftest.tar.gz && \
    mv conftest /usr/local/bin && \
    rm -f conftest.tar.gz && \
    wget https://openpolicyagent.org/downloads/v${OPA_VERSION}/opa_linux_amd64_static \
      -O opa && \
    chmod 755 ./opa && \
    mv opa /usr/local/bin

COPY policy/ /root/policy/
COPY scripts/ /root/scripts/
COPY terraform/ /root/terraform/
COPY Makefile /root/

RUN git config --global --add safe.directory /root

WORKDIR /root

ENTRYPOINT ["/root/scripts/entrypoint.sh"]
CMD ["hello-world"]
