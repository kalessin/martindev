Development environment with:

- python 3
- R
- octave
- scrapy suite
- scrapinghub suite
- jupyter notebook (aka ipython notebook)
- scipy & sklearn & matplotlib
- neurolab
- TensorFlow (no GPU support*)
- pandas
- geopandas & mplleaflet

* If you have a GPU, follow rules here to install TensorFlow with GPU support instead:

`https://www.tensorflow.org/install/install_linux#determine_which_tensorflow_to_install`_

Install/Run
===========

Build instructions::

    docker build -t kalessin/martindev .

Alternatively::

    docker pull kalessin/martindev:latest

Run instructions::

    docker run -ti kalessin/martindev /bin/bash

Running Jupyter notebook
========================

If want to run jupyter, don't forget to map the port to host machine::

    docker run -ti -v <host notebooks folder>:/app/jupyter -p 127.0.0.1:8888:8888 kalessin/martindev /bin/bash

And once logged in container console, run jupyter notebook with following options::

    $ jupyter notebook --no-browser --ip=0.0.0.0

So you can access from host by pointing browser to 127.0.0.1:8888

Running X applications
======================


If some application running in the container needs access to host X server, first run following commands in host machine running X server::

    XSOCK=/tmp/.X11-unix
    XAUTH=/tmp/.docker.xauth
    touch $XAUTH
    xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

Those steps make available the host X socket and authorization credentials for applications running in container.

Then run a new container as follows::

    docker run -ti -v $XSOCK:$XSOCK:rw -v $XAUTH:$XAUTH:rw -e DISPLAY -e XAUTHORITY=${XAUTH} kalessin/martindev /bin/bash

It is not the safest way to grant applications running in container access X server as root, but it is the simplest one. For more elaborated alternatives, check
`<http://wiki.ros.org/docker/Tutorials/GUI>`_
