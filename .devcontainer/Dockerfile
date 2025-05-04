# Base image
FROM debian:bookworm-20250407-slim

# Install required packages
RUN apt-get update
RUN apt-get --no-install-recommends -y upgrade
RUN apt-get install --no-install-recommends -y git cmake ninja-build gperf \
    ccache dfu-util device-tree-compiler wget \
    python3-dev python3-pip python3-setuptools python3-tk python3-wheel python3-venv \
    xz-utils file make gcc gcc-multilib g++-multilib libsdl2-dev libmagic1 ssh

# Create venv and activate it by prepending the PATH variable (activation script not used in Docker..)
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install the zephyr west meta-tool from the python repositories
RUN pip install west

# Prepare west manifest and west workspace directory /opt/zephyr-workspace
# First, only grab the slimmest version by using the basic.west.yml that only includes support for ARM
RUN mkdir -p /opt/zephyr-workspace/west-manifest
COPY basic.west.yml /opt/zephyr-workspace/west-manifest/west.yml
WORKDIR /opt/zephyr-workspace/
RUN [ "west", "init", "-l", "west-manifest" ]
RUN [ "west", "update"]
RUN [ "west", "packages", "pip", "--install"]

# Then add support for additional boards if necessary
# This allows for Docker build cache to be used without fetching the whole zephyr repo
# again for every target change you do
COPY toolchains.west.yml /opt/zephyr-workspace/west-manifest/west.yml
RUN [ "west", "update"]
RUN [ "west", "packages", "pip", "--install"]

# Install the SDKs and toolchains for the desired targets.
RUN [ "west", "sdk", "install", "-b", "/opt/zephyr-sdk", "-t", "arm-zephyr-eabi", "riscv64-zephyr-elf"]

# Add the ZEPHYR_BASE environment variable to allow west commands to be used from anywhere
ENV ZEPHYR_BASE=/opt/zephyr-workspace/zephyr

# Add helper script for building zephyr apps from anywhere
# Usage:
# build buildcommand.sh
# Where buildcommand.sh contains the actual west build command for your app.
# the resulting binaries will be copied to ./bin in your working directory
COPY build.sh /usr/bin/build
RUN chmod +x /usr/bin/build
