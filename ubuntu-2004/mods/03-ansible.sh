#!/bin/bash -e

# Shellcheck fixes for: SC2086, SC2181
dependencies="software-properties-common python3 python3-pip"
package1="ansible"

check_os () {
  if [ "$(grep -Ei 'VERSION_ID="16.04"' /etc/os-release)" ];
  then
    echo -e "\nSystem OS is Ubuntu. Version is 16.04.\n\n###\tProceeding with SCRIPT Execution\t###\n"
  elif [ "$(grep -Ei 'VERSION_ID="18.04"' /etc/os-release)" ];
  then
    echo -e "\nSystem OS is Ubuntu. Version is 18.04.\n\n###\tProceeding with SCRIPT Execution\t###\n"
  elif [ "$(grep -Ei 'VERSION_ID="20.04"' /etc/os-release)" ];
  then
    echo -e "\nSystem OS is Ubuntu. Version is 20.04.\n\n###\tProceeding with SCRIPT Execution\t###\n"
  else
    echo -e "\nThis is neither Ubuntu 16.04, Ubuntu 18.04 or 20.04.\n\n###\tScript execution HALTING!\t###\n"
    exit 2
  fi
}

setup_dependencies () {
  for dependency in ${dependencies};
  do
    if dpkg -s "${dependency}" &> /dev/null;
      then
        echo -e "\n${dependency} is already available and installed within the system."
      else
        echo -e "About to install:\t${dependency}."
        DEBIAN_FRONTEND=non-interactive apt-get install "${dependency}" -y
    fi
  done
}

check_if_ansible_installed () {
  if ${package1} --version &> /dev/null;
    then
      echo -e "\nYES: ${package1} is IN an installed state within the system.\n"
      ansible_verify
      exit 0
    else
      echo -e "\nNO: ${package1} is NOT IN an installed state.\n"
  fi
}


ansible_installer () {
  sudo -H python3 -m pip install ansible

}

case "$1" in
  check)
    check_os
    check_if_ansible_installed
    ;;
  install)
    check_os
    setup_dependencies
    check_if_ansible_installed
    echo -e "\nInstallation beginning for:\t${package1}\n"
    ansible_installer
    ;;
  *)
    echo -e $"\nUsage:\t $0 check\nChecks if ${package1} is installed on the system and operational.\n\n"
    echo -e $"Usage:\t $0 install\nFor installing ${package1} from the system.\n\n"
    exit 1
esac
