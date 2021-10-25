FROM ubuntu:bionic-20180125@sha256:d6f6cc62b6bed64387d84ca227b76b9cc45049b0d0aefee0deec21ed19a300bf

COPY . /opt/dissertation/

SHELL ["/bin/bash", "-c"]

# Define default working directory.
WORKDIR /opt/dissertation

# Prevent interactive time zone config.
# adapted from https://askubuntu.com/a/1013396
ENV DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get update -q \
  && apt-get install -qy --no-install-recommends \
    bibtool \
    git \
    make \
    moreutils \
  && rm -rf /var/lib/apt/lists/*

# texlive-full "without the beef"
# adapted from https://gist.github.com/wkrea/b91e3d14f35d741cf6b05e57dfad8faf
RUN \
  apt-get update -q \
  && apt-get install -qy $( \
    apt-get --assume-no install texlive-full | \
    awk '/The following additional packages will be installed/{f=1;next} /Suggested packages/{f=0} f' | \
    tr ' ' '\n' \
    | grep -vP 'doc$' \
    | grep -vP 'texlive-lang' \
    | grep -vP 'latex-cjk' \
    | tr '\n' ' '\
  ) \
  && apt-get install texlive-lang-english \
  && rm -rf /var/lib/apt/lists/*

CMD ["bash"]
