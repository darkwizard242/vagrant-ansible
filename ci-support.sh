#!/bin/bash
set -ev


if [ "${TRAVIS_BRANCH}" = "master" ];
then
  echo -e "\nBranch is: master"
else
  echo -e "\nBranch is not: master"
fi
