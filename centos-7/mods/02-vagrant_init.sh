#!/bin/bash -eu

yum install kernel-devel -y


if systemctl list-unit-files | grep -q dkms.service; then
  sudo systemctl start dkms
  sudo systemctl enable dkms
fi

# Custom VBoxAdditions mount and setup required by vagrant
mkdir -pv /mnt/virtualbox
sudo mount -v -o loop,ro /home/vagrant/VBoxGuest*.iso /mnt/virtualbox
sudo sh /mnt/virtualbox/VBoxLinuxAdditions.run --nox11 || :
/sbin/rcvboxadd quicksetup all
ln -vs /opt/VBoxGuestAdditions-*/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
sudo umount -v /mnt/virtualbox
rm -rfv /home/vagrant/VBoxGuest*.iso
