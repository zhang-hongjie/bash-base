FROM alpine:3.12 as standard

RUN apk add --no-cache bash

COPY LICENSE CHANGELOG.md README.md CODE_OF_CONDUCT.md CONTRIBUTING.md /opt/bash-base/
COPY docs /opt/bash-base/docs
COPY man /opt/bash-base/man
COPY src /opt/bash-base/bin

ENV PATH /opt/bash-base/bin/:$PATH
