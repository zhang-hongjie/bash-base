# Build image with Automated Builds using Docker Hub hooks.
FROM alpine:3.12 as standard
RUN apk add --no-cache bash
COPY docs man LICENSE CHANGELOG.md README.md CODE_OF_CONDUCT.md CONTRIBUTING.md /opt/bash-base/
COPY src /opt/bash-base/bin
ENV PATH /opt/bash-base/bin/:$PATH
