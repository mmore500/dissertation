FROM ubuntu:bionic-20180125@sha256:d6f6cc62b6bed64387d84ca227b76b9cc45049b0d0aefee0deec21ed19a300bf

COPY . /opt/dissertation/

SHELL ["/bin/bash", "-c"]

# Define default working directory.
WORKDIR /opt/dissertation

# Prevent interactive time zone config.
# adapted from https://askubuntu.com/a/1013396
ENV DEBIAN_FRONTEND=noninteractive

RUN \
  ln -snf /usr/share/zoneinfo/Etc/UTC /etc/localtime \
  && echo "Etc/UTC" > /etc/timezone \
  && apt-get update -q \
  && apt-get install -qy --no-install-recommends \
    bibtool \
    git \
    make \
    moreutils \
    texlive-full \
  && rm -rf /var/lib/apt/lists/*

CMD ["bash"]
