#!/usr/bin/env bash

if [ -d "$1" ]; then
    docker build . -t pyrevengine
    docker run -it --volume "$1":/input:rw pyrevengine
else
  echo "The argument is not a directory."
fi
