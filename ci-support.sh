#!/bin/bash
set -ev


if [ "${TRAVIS_BRANCH}" = "master" ];
then
  echo "\nBranch is: master"
else
  echo "\nBranch is not: master"
fi
