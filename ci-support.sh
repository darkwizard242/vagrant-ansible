#!/bin/bash -e

BUILDSCRIPT_MASTER="build.json"
BUILDSCRIPT_NON_MASTER="template-branch-others.json"


if [ "${TRAVIS_BRANCH}" = "master" ];
then
  echo -e "\nBranch is:\t${TRAVIS_BRANCH}"
else
  echo -e "\nBranch is:\t${TRAVIS_BRANCH}"
  echo -e "\nPath is:\t${PATH_TO_BUILDSCRIPT}"
  echo -e "\nPacker template file is:\t${BUILDSCRIPT_NON_MASTER}"
  cd ${PATH_TO_BUILDSCRIPT}
  echo -e "\nValidating packer template file:\t${BUILDSCRIPT_NON_MASTER}"
  ../$BUILDER validate ${BUILDSCRIPT_NON_MASTER}
  echo -e "\nRunning packer build for template file:\t${BUILDSCRIPT_NON_MASTER}"
  sudo ../$BUILDER build -timestamp-ui -color=false ${BUILDSCRIPT_NON_MASTER}
fi
