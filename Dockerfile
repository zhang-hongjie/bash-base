FROM alpine:3.12
#FROM docker:latest

RUN apk add --no-cache bash curl nano git

COPY scripts/verify-by-spec.sh LICENSE CHANGELOG.md README.md CODE_OF_CONDUCT.md CONTRIBUTING.md /opt/bash-base/
COPY docs /opt/bash-base/docs
COPY man /opt/bash-base/man
COPY spec /opt/bash-base/spec
COPY src /opt/bash-base/bin

ENV PATH /opt/bash-base/bin/:$PATH
