#!/bin/bash
# Set a function for error handling
error_handler() {
  echo "Error: $1" >&2  # Send error to stderr
  exit 1
}

# Clone dotfiles repository
echo "Cloning dotfiles..."
git clone https://github.com/flipsidecreations/dotfiles.git || error_handler "Failed to clone dotfiles repository."
cd dotfiles || error_handler "Failed to change directory to dotfiles."

# Check for install.sh in the cloned dotfiles repository
echo "Checking for install.sh..."
ls -l install.sh
if [ $? -ne 0 ]; then
    echo "install.sh not found.  Check the URL or the repository content."
    exit 1
fi

# Make install.sh executable (if it isn't already)
chmod +x install.sh  # <--- ADD THIS LINE

echo "Running install.sh..."
./install.sh || error_handler "Failed to run install.sh."

# Switch to root user
echo "Switching to root user..."
sudo -i || error_handler "Failed to switch to root user."

# Re-clone dotfiles (important to ensure the new root user has them)
echo "Re-cloning dotfiles as root..."
git clone https://github.com/flipsidecreations/dotfiles.git || error_handler "Failed to re-clone dotfiles as root."
cd dotfiles || error_handler "Failed to change directory to dotfiles (as root)."
./install.sh || error_handler "Failed to run install.sh (as root)."

# Mount the CD-ROM and run the installer, then unmount
echo "Mounting CD-ROM and running installer..."
mount /dev/cdrom /mnt || error_handler "Failed to mount CD-ROM."
# Check contents of CD-ROM
echo "Listing contents of CD-ROM..."
ls -l /mnt
# Find the actual path to the installer on the CD-ROM
#  Adjust the path below accordingly
bash -c "bash /mnt/Linux/install.sh" || error_handler "Failed to run installer from CD-ROM."
#bash -c "bash /mnt/install.sh" || error_handler "Failed to run installer from CD-ROM."
umount /mnt || error_handler "Failed to unmount CD-ROM."

# Update and upgrade the system
echo "Updating and upgrading system..."
apt update -y || error_handler "Failed to update package lists."
apt upgrade -y || error_handler "Failed to upgrade packages."
apt dist-upgrade -y || error_handler "Failed to perform distribution upgrade."
apt autoremove -y || error_handler "Failed to remove unnecessary packages."
apt autoclean -y || error_handler "Failed to clean the package cache."

# Reboot the system
echo "Rebooting system..."
reboot
