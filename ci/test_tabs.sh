#!/bin/bash

SOURCE_HASH=$( find -path ./submodule -prune -false -o -type f | sort | xargs cat | sha1sum )

bash ./ci/replace_tabs.sh

if [ "${SOURCE_HASH}" == "$( find -path ./submodule -prune -false -o -type f | sort | xargs cat | sha1sum )" ];
then
  exit 0 # success
else
  echo "tab characters detected, run ./ci/replace_tabs.sh locally to find & fix"
  exit 1 # failure
fi
