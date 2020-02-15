#!/bin/bash -e

BUILDSCRIPT_MASTER="build.json"
BUILDSCRIPT_NON_MASTER="template-branch-others.json"

build_template () {
  echo -e "\nBranch is: ${TRAVIS_BRANCH}"
  echo -e "\nBox is: ${BOX}"
  echo -e "\nPacker template file is: $1"
  cd ${BOX}
  echo -e "\nValidating packer template file: $1"
  ../${BUILDER} validate $1
  echo -e "\nRunning packer build for template file: $1"
  sudo ../${BUILDER} build -timestamp-ui -color=false $1
}

if [ "$(git branch --show-current)" = "master" ];
then
  build_template ${BUILDSCRIPT_MASTER}
else
  build_template ${BUILDSCRIPT_NON_MASTER}
fi
