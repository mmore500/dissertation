#!/bin/bash

# adapted from https://www.linsoftware.com/how-to-check-for-git-merge-conflicts-in-travis-ci/

found_merge_markers=$(grep -EHlr --exclude=test_merge_conflict_markers.sh --exclude-dir=submodules '<<<<<<< HEAD|>>>>>>>' .)

if [ -z "$found_merge_markers" ]
then
  exit 0 # success
else
  echo "git merge conflict markers found"
  echo $found_merge_markers
  exit 1 # failure
fi
