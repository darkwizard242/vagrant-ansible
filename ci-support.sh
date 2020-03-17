#!/bin/bash -e

BUILDSCRIPT_MASTER="template-branch-master.json"
BUILDSCRIPT_NON_MASTER="template-branch-others.json"
# VERSION=$(date +"%Y%m%d%H%M%S")

build_template () {
  echo -e "\nBranch is: ${TRAVIS_BRANCH}"
  echo -e "\nBox is: ${BOX}"
  echo -e "\nPacker template file is: $1"
  cd "${BOX}"
  echo -e "\nValidating packer template file: $1"
  ../"${BUILDER}" validate "$1"
  echo -e "\nRunning packer build for template file: $1"
  sudo PACKER_LOG=1 ../"${BUILDER}" build -timestamp-ui -color=false -force "$1"
}

if [[ "${TRAVIS_BRANCH}" = "master" && ${TRAVIS_PULL_REQUEST_SLUG} = "" ]];
then
  build_template ${BUILDSCRIPT_MASTER}
elif [ "${TRAVIS_PULL_REQUEST_BRANCH}" = "master" ];
then
  build_template ${BUILDSCRIPT_NON_MASTER}
else
  build_template ${BUILDSCRIPT_NON_MASTER}
fi
