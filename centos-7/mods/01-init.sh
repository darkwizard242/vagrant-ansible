#!/bin/bash -e

# Shellcheck fixes for: SC2006, SC2086, SC2129, SC2181

yum update -y
yum upgrade -y


# Apply Vagrant public key.
echo "Applying Vagrant public key"
sudo mkdir -pv /home/vagrant/.ssh
sudo curl -fsSLo /home/vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub

# Change owner and group on SSH authorized keys file for vagrant user
echo "Setting appropriate permissions and ownership for /home/vagrant/.ssh"
sudo chown -Rv vagrant:vagrant /home/vagrant/.ssh
sudo chmod -v 700 /home/vagrant/.ssh
sudo chmod -v 600 /home/vagrant/.ssh/authorized_keys


# Configure Vagrant for no password sudo
echo "Configuring Vagrant for passwordless sudo"
sudo cat > /etc/sudoers.d/vagrant <<'EOF'
Defaults:vagrant !requiretty
vagrant ALL=(ALL) NOPASSWD: ALL
EOF
sudo chmod -v 440 /etc/sudoers.d/vagrant


# Install necessary libraries for guest additions and Vagrant NFS Share
# removed linux-headers-$(uname -r) nfs-common build-essentials from libraries list
libraries="deltarpm epel-release initscripts dkms"
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
dependencies="curl wget inxi tree vim bzip2 tar"
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
# usermod -aG sudo vagrant
