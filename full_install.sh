#!/bin/bash

# Clone dotfiles repository
git clone https://github.com/flipsidecreations/dotfiles.git
cd dotfiles

# Run the installation script
./install.sh

# Switch to root user
sudo -i

# Re-clone dotfiles (important to ensure the new root user has them)
git clone https://github.com/flipsidecreations/dotfiles.git
cd dotfiles
./install.sh

# Mount the CD-ROM and run the installer, then unmount
bash -c "mount /dev/cdrom /mnt && bash /mnt/Linux/install.sh && umount /mnt"

# Update and upgrade the system
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt autoremove -y
apt autoclean -y

# Reboot the system
reboot
