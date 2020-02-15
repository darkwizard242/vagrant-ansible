#!/bin/bash -x
set -e

BUILDSCRIPT_MASTER="build.json"
BUILDSCRIPT_NON_MASTER="template-branch-master.json"


if [ "${TRAVIS_BRANCH}" = "master" ];
then
  echo -e "\nBranch is: ${TRAVIS_BRANCH}"
else
  echo -e "\nBranch is: ${TRAVIS_BRANCH}"
  echo -e "\nPath is: ${PATH_TO_BUILDSCRIPT}"
  echo -e "\nPacker template file is: ${BUILDSCRIPT_NON_MASTER}"
  cd ${PATH_TO_BUILDSCRIPT}
  pwd
  echo -e "\nValidating packer template file: ${BUILDSCRIPT_NON_MASTER}"
  ../$BUILDER validate ${BUILDSCRIPT_NON_MASTER}
  echo -e "\nRunning packer build for template file: ${BUILDSCRIPT_NON_MASTER}"
  sudo ../$BUILDER build -timestamp-ui -color=false ${BUILDSCRIPT_NON_MASTER}
fi
