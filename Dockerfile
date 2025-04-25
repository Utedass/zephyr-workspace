FROM debian:bookworm-20250407-slim

RUN apt-get update
RUN apt-get --no-install-recommends -y upgrade
RUN apt-get install --no-install-recommends -y git cmake ninja-build gperf \
            ccache dfu-util device-tree-compiler wget \
            python3-dev python3-pip python3-setuptools python3-tk python3-wheel python3-venv \
            xz-utils file make gcc gcc-multilib g++-multilib libsdl2-dev libmagic1

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install west
