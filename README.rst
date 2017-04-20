Development environment with:

- python 2
- python 3
- R
- scrapy suite
- scrapinghub suite
- octave

Build instructions::

    docker build -t kalessin/martindev .

Alternatively::

    docker pull kalessin/martindev:latest

Run instructions::

    docker run -ti -v <git directory>:/app/git kalessin/martindev /bin/bash

Push::

    docker push kalessin/martindev:latest
