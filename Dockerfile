FROM thomasweise/docker-texlive-full:1.1

COPY . /opt/dissertation/

SHELL ["/bin/bash", "-c"]

# Define default working directory.
WORKDIR /opt/dissertation

# Prevent interactive time zone config.
# adapted from https://askubuntu.com/a/1013396
ENV DEBIAN_FRONTEND=noninteractive

RUN \
  echo 'Acquire::http::Timeout "60";' >> "/etc/apt/apt.conf.d/99timeout" \
    && \
  echo 'Acquire::ftp::Timeout "60";' >> "/etc/apt/apt.conf.d/99timeout" \
    && \
  echo 'Acquire::Retries "100";' >> "/etc/apt/apt.conf.d/99timeout" \
    && \
  echo "buffed apt-get resiliency"

# --no-cache see https://askubuntu.com/a/1267194
RUN \
  apt-get update -q --allow-unauthenticated --no-cache \
  && apt-get install -qy --no-install-recommends \
    bibtool \
    git \
    make \
    moreutils \
  && rm -rf /var/lib/apt/lists/*

CMD ["bash"]
