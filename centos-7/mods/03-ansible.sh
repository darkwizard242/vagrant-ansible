#!/bin/bash -e

# Shellcheck fixes for: SC2086, SC2181
package="ansible"


check_if_ansible_installed () {
  if ${package} --version &> /dev/null;
    then
      echo -e "\nYES: ${package} is IN an installed state within the system.\n"
      ansible_verify
      exit 0
    else
      echo -e "\nNO: ${package} is NOT IN an installed state.\n"
  fi
}

ansible_installer () {
  yum install ${package} -y
}

ansible_uninstaller () {
  yum remove ${package} -y
}

case "$1" in
  check)
    check_if_ansible_installed
    ;;
  install)
    check_if_ansible_installed
    echo -e "\nInstallation beginning for:\t${package}\n"
    ansible_installer
    ;;
  uninstall)
    echo -e "\nPurging beginning for:\t${package}\n"
    ansible_uninstaller
    ;;
  *)
    echo -e $"\nUsage:\t $0 check\nChecks if ${package} is installed on the system and operational.\n\n"
    echo -e $"Usage:\t $0 install\nFor installing ${package} from the system.\n\n"
    echo -e $"Usage:\t $0 uninstall\nFor uninstalling/purging ${package} from the system.\n"
    exit 1
esac
