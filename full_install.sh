#!/bin/bash

# Set a function for error handling
error_handler() {
  echo "Error: $1" >&2
  exit 1
}

# Function to execute commands requiring sudo, prompting for password
sudo_exec() {
  local command="$@"  # Capture all arguments as a single string
  echo "Executing with sudo: $command"
  eval "$command"
}

# Clone dotfiles repository
echo "Cloning dotfiles..."
git clone https://github.com/flipsidecreations/dotfiles.git || error_handler "Failed to clone dotfiles repository."
cd dotfiles || error_handler "Failed to change directory to dotfiles."

# Run the installation script
echo "Running install.sh..."
./install.sh || error_handler "Failed to run install.sh."

# Switch to root user using sudo
echo "Switching to root user (prompting for sudo password)..."
sudo_exec "git clone https://github.com/flipsidecreations/dotfiles.git" || error_handler "Failed to clone dotfiles as root."
sudo_exec "cd dotfiles" || error_handler "Failed to change directory as root."
sudo_exec "./install.sh" || error_handler "Failed to run install.sh (as root)."

# Mount the CD-ROM and run the installer, then unmount
echo "Mounting CD-ROM and running installer..."
sudo_exec "mount /dev/cdrom /mnt" || error_handler "Failed to mount CD-ROM."
sudo_exec "bash -c \"bash /mnt/Linux/install.sh\"" || error_handler "Failed to run installer from CD-ROM."
sudo_exec "umount /mnt" || error_handler "Failed to unmount CD-ROM."


# Update and upgrade the system
echo "Updating and upgrading system..."
sudo_exec "apt update -y" || error_handler "Failed to update package lists."
sudo_exec "apt upgrade -y" || error_handler "Failed to upgrade packages."
sudo_exec "apt dist-upgrade -y" || error_handler "Failed to perform distribution upgrade."
sudo_exec "apt autoremove -y" || error_handler "Failed to remove unnecessary packages."
sudo_exec "apt autoclean -y" || error_handler "Failed to clean the package cache."

# Reboot the system
echo "Rebooting system..."
sudo_exec "reboot"
