FROM python:2
ARG PIP_INDEX_URL
ARG PIP_TRUSTED_HOST
ARG APT_PROXY
ONBUILD ENV PIP_TRUSTED_HOST=$PIP_TRUSTED_HOST PIP_INDEX_URL=$PIP_INDEX_URL
ONBUILD RUN test -n $APT_PROXY && echo 'Acquire::http::Proxy \"$APT_PROXY\";' \
    >/etc/apt/apt.conf.d/proxy

# TERM needs to be set here for exec environments
# PIP_TIMEOUT so installation doesn't hang forever
ENV TERM=xterm \
    PIP_TIMEOUT=180

RUN apt-get update -qq && \
    apt-get install -qy \
        netbase ca-certificates apt-transport-https \
        build-essential locales \
        libxml2-dev \
        libssl-dev \
        libxslt1-dev \
        libmysqlclient-dev \
        libpq-dev \
        libevent-dev \
        libffi-dev \
        libpcre3-dev \
        libz-dev \
        unixodbc unixodbc-dev \
        telnet vim htop iputils-ping curl wget lsof git sudo \
        ghostscript \
        ruby2.1 ruby2.1-dev \
        python3 python3-pip

# http://unix.stackexchange.com/questions/195975/cannot-force-remove-directory-in-docker-build
#        && rm -rf /var/lib/apt/lists

# adding custom locales to provide backward support with scrapy cloud 1.0
COPY locales /etc/locale.gen
RUN locale-gen

COPY requirements.txt /requirements.txt
COPY stack-requirements.txt /stack-requirements.txt
COPY requirements3.txt /requirements3.txt

RUN gem2.1 install travis -v 1.8.8 --no-rdoc --no-ri

RUN pip install --no-cache-dir -r stack-requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN pip3 install -r requirements3.txt

COPY vimrc /root/.vimrc
RUN mkdir -p /root/backup/vim/swap

RUN apt-get install -qy octave
RUN apt-get install -qy aptitude ack-grep r-base r-base-core r-base-core-dbg r-base-dev

RUN pip3 install --upgrade pip
RUN pip3 install jupyter
RUN apt-get install less
RUN pip3 install scipy==0.19.0 sklearn
RUN pip3 install neurolab
RUN pip3 install tensorflow==1.2.0 matplotlib==2.0.2 pillow==4.1.1
RUN pip3 install scrapely
RUN pip3 install numpy==1.13.0
RUN pip3 install pandas
RUN pip3 install xlrd
RUN pip3 install geopandas
RUN pip3 install mplleaflet

ADD . /app

WORKDIR /app
