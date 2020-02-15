#!/bin/bash
set -ev

BUILDSCRIPT_MASTER="build.json"
BUILDSCRIPT_NON_MASTER="template-branch-master.json"


if [ "${TRAVIS_BRANCH}" = "master" ];
then
  echo -e "\nBranch is: ${TRAVIS_BRANCH}"
else
  echo -e "\nBranch is: ${TRAVIS_BRANCH}"
  cd ${PATH_TO_BUILDSCRIPT}
  echo -e "\nValidating packer template file: {BUILDSCRIPT_NON_MASTER}"
  ../$BUILDER validate ${BUILDSCRIPT_NON_MASTER}
  echo -e "\nVRunning packer build for template file: {BUILDSCRIPT_NON_MASTER}"
  sudo ../$BUILDER build -timestamp-ui -color=false ${BUILDSCRIPT_NON_MASTER}
fi
