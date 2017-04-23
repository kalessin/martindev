Development environment with:

- python 2
- python 3
- R
- jupyter notebook (aka ipython notebook)
- scrapy suite
- scrapinghub suite
- octave

Build instructions::

    docker build -t kalessin/martindev .

Alternatively::

    docker pull kalessin/martindev:latest

Push::

    docker push kalessin/martindev:latest

Run instructions::

    docker run -ti -v <git directory>:/app/git kalessin/martindev /bin/bash

If want to run jupyter, don't forget to map the port to host machine::

    docker run -ti -v <git directory>:/app/git -p 127.0.0.1:8888:8888 kalessin/martindev /bin/bash

And once logged in container console, run jupyter notebook with following options::

    $ jupyter notebook --no-browser --ip=0.0.0.0

So you can access from host by pointing browser to 127.0.0.1:8888
