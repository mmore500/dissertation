FROM thomasweise/docker-texlive-full:2.0

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

# fix jdk install bug https://github.com/geerlingguy/ansible-role-java/issues/64#issuecomment-597132394
RUN mkdir -p /usr/share/man/man1/

RUN \
  apt-get clean \
  && apt-get update -q --allow-unauthenticated \
  && apt-get install -qy --no-install-recommends \
    bibtool \
    git \
    make \
    moreutils \
    pdftk \
  && rm -rf /var/lib/apt/lists/*

CMD ["bash"]
