# Build image with Automated Builds using Docker Hub hooks.
FROM alpine:3.12 as standard
COPY src/* docs/* man/* LICENSE CHANGELOG.md README.md CODE_OF_CONDUCT.md CONTRIBUTING.md /opt/bash-base/
ENV PATH /opt/bash-base/:$PATH
