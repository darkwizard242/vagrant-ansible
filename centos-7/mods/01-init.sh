#!/bin/bash -e

# Shellcheck fixes for: SC2006, SC2086, SC2129, SC2181

yum update

# Add vagrant user to sudoers.
{
  echo "vagrant ALL=(ALL) NOPASSWD: ALL"
} >> /etc/sudoers

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers


# Install necessary libraries for guest additions and Vagrant NFS Share
# removed linux-headers-$(uname -r) nfs-common build-essentials from libraries list
libraries="dkms"
for library in $libraries;
do
  if yum list installed "$library" &> /dev/null;
    then
      echo -e "\n$library is already available and installed within the system.\n"
    else
      echo -e  "\nAbout to install $library.\n"
      yum install "$library" -y
  fi
done

# Install necessary dependencies
# took out xvfb from dependencies list dirmngr
dependencies="curl wget inxi tree sudo"
for dependency in $dependencies;
do
  if yum list installed "$dependency" &> /dev/null;
    then
      echo -e "\n$dependency is already available and installed within the system.\n"
    else
      echo -e  "\nAbout to install $dependency.\n"
      yum install "$dependency" -y
  fi
done

# Add vagrant user to sudo group
usermod -aG sudo vagrant
