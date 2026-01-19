FROM jenkins/jenkins:lts-jdk17
USER root
RUN apt-get update && apt-get install -y bash curl unzip git nodejs npm mkdir
WORKDIR /opt
RUN curl --location --show-error -O --url "https://bun.sh/install"
RUN bash /opt/install
# Needs docker build --progress=plain to work correctly
# RUN which bash
# WORKDIR /usr/bin
# RUN ls
RUN npm install -g @ts.adligo.org/slink@1.5.9 typescript tsx ts-node @types/node
ENV PATH="$PATH:/root/.bun/bin"
ENV USHELL="/bin/bash"
ENV ADLIGO_DOCKER_IMAGE_ID=mvpa_bm.ts.adligo.org/jenkins/Dockerfile_2026-01-19#1
