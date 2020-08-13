# Build image with Automated Builds using Docker Hub hooks.
FROM alpine:3.12 as standard
COPY src/* LICENSE CHANGELOG.md README.md /opt/bash-base/
ENV PATH /opt/shellspec/:$PATH
