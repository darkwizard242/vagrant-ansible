#!/bin/bash -eu


# Custom VBoxAdditions mount and setup required by vagrant
mkdir -pv /mnt/virtualbox
mount -v -o loop /home/vagrant/VBoxGuest*.iso /mnt/virtualbox
sh /mnt/virtualbox/VBoxLinuxAdditions.run
/sbin/rcvboxadd quicksetup all
ln -vs /opt/VBoxGuestAdditions-*/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
umount -v /mnt/virtualbox
rm -rfv /home/vagrant/VBoxGuest*.iso
