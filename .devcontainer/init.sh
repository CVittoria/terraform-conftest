#!/bin/bash

TERRAFORM_DOCS_VERSION="0.16.0"

cd /

go install github.com/terraform-docs/terraform-docs@v${TERRAFORM_DOCS_VERSION}

ln -s /go/bin/* /usr/local/go/bin
