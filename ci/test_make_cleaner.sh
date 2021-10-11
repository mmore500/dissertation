#!/bin/bash

SOURCE_HASH=$( find -path ./submodule -prune -false -o -type f | sort | xargs cat | sha1sum )

make cleaner

if [ "${SOURCE_HASH}" == "$( find -path ./submodule -prune -false -o -type f | sort | xargs cat | sha1sum )" ];
then
  exit 0 # success
else
  echo "compile artifacts detected, run make cleaner locally to find & fix"
  exit 1 # failure
fi
