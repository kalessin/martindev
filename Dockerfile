FROM buildpack-deps:bionic
ARG PIP_INDEX_URL
ARG PIP_TRUSTED_HOST
ARG APT_PROXY
ONBUILD ENV PIP_TRUSTED_HOST=$PIP_TRUSTED_HOST PIP_INDEX_URL=$PIP_INDEX_URL
ONBUILD RUN test -n $APT_PROXY && echo 'Acquire::http::Proxy \"$APT_PROXY\";' >/etc/apt/apt.conf.d/proxy

# TERM needs to be set here for exec environments
# PIP_TIMEOUT so installation doesn't hang forever
ENV TERM=xterm PIP_TIMEOUT=180 SHUB_ENFORCE_PIP_CHECK=1
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -qy python3 libpython3-all-dev aptitude

RUN apt-get install -qy \
        netbase ca-certificates apt-transport-https \
        build-essential locales \
        libxml2-dev \
        libssl-dev \
        libxslt1-dev \
        default-libmysqlclient-dev \
        libpq-dev \
        libevent-dev \
        libffi-dev \
        libpcre3-dev \
        libz-dev \
        unixodbc unixodbc-dev \
        telnet vim htop iputils-ping curl wget lsof git sudo \
        ghostscript \
        ruby ruby-dev \
        less ack-grep groff \
        octave r-base r-base-core r-base-core-dbg r-base-dev

# http://unix.stackexchange.com/questions/195975/cannot-force-remove-directory-in-docker-build
#        && rm -rf /var/lib/apt/lists

# adding custom locales to provide backward support with scrapy cloud 1.0
COPY locales /etc/locale.gen
RUN locale-gen

RUN gem install travis -v 1.8.8 --no-rdoc --no-ri
RUN apt-get install -qy python3-pip graphviz libclang-4.0-dev python-clang-4.0 cmake libboost-dev
RUN pip3 install --upgrade keyrings.alt
RUN pip3 install --upgrade pip

COPY stack-requirements.txt /stack-requirements.txt
RUN pip3 install --no-cache-dir -r stack-requirements.txt

COPY requirements.txt /requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

COPY extras.sh /extras.sh
RUN ./extras.sh

COPY vimrc /root/.vimrc
RUN mkdir -p /root/backup/vim/swap

ADD . /app

WORKDIR /app
