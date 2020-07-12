#!/bin/bash -e

# Shellcheck fixes for: SC2086, SC2181
dependencies="software-properties-common python3 python3-pip"
package1="ansible"

check_os () {
  if [ "$(grep -Ei 'VERSION_ID="10' /etc/os-release && grep -Ei 'ID="debian"' /etc/os-release)" ];
  then
    echo -e "\nSystem OS is Debian. Version is 10.\n\n###\tProceeding with SCRIPT Execution\t###\n"
  elif [ "$(grep -Ei 'VERSION_ID="9' /etc/os-release && grep -Ei 'ID="debian"' /etc/os-release)" ];
  then
    echo -e "\nSystem OS is Debian. Version is 9.\n\n###\tProceeding with SCRIPT Execution\t###\n"
  elif [ "$(grep -Ei 'VERSION_ID="8' /etc/os-release && grep -Ei 'ID="debian"' /etc/os-release)" ];
  then
    echo -e "\nSystem OS is Debian. Version is 8.\n\n###\tProceeding with SCRIPT Execution\t###\n"
  else
    echo -e "\nThis is neither Debian 8, 9 or 10.\n\n###\tScript execution HALTING!\t###\n"
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

add_ansible_repo () {
  echo -e "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" | sudo tee -a /etc/apt/sources.list.d/ansible.list
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
  DEBIAN_FRONTEND=non-interactive apt-get update
}

ansible_installer () {
  DEBIAN_FRONTEND=non-interactive apt-get install ${package1} -y
  # echo -e "\nSetting remote_tmp to /tmp dir in /etc/ansible/ansible.cfg\n"
  # sed -i 's/^#remote_tmp.*$/remote_tmp\ \=\ \/tmp/' /etc/ansible/ansible.cfg
}

ansible_uninstaller () {
  DEBIAN_FRONTEND=non-interactive apt-get purge ${package1} -y
}

case "$1" in
  check)
    check_if_ansible_installed
    ;;
  install)
    setup_dependencies
    check_if_ansible_installed
    echo -e "\nInstallation beginning for:\t${package1}\n"
    add_ansible_repo
    ansible_installer
    ;;
  uninstall)
    echo -e "\nPurging beginning for:\t${package1}\n"
    ansible_uninstaller
    ;;
  *)
    echo -e $"\nUsage:\t $0 check\nChecks if ${package1} is installed on the system and operational.\n\n"
    echo -e $"Usage:\t $0 install\nFor installing ${package1} from the system.\n\n"
    echo -e $"Usage:\t $0 uninstall\nFor uninstalling/purging ${package1} from the system.\n"
    exit 1
esac
