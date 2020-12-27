#! /bin/bash

# Post install script
echo "Orion Arch Config"

# Set date time
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc --utc

# Set locale to en_US.UTF-8 UTF-8
sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Set hostname
echo "orion" >> /etc/hostname
echo "127.0.1.1 orion.localdomain orion" >> /etc/hosts

# Set root password
echo "Set root password"
passwd

# Install bootloader
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# Create new user
echo "Creating new user..."
useradd -m -G wheel,power,audio,storage,network -s /usr/bin/zsh rohan
passwd rohan

echo "Adding permissions"
echo "rohan ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
echo "set-sink-port 0 analog-output-headphones" | sudo tee -a /etc/pulse/default.pa
echo "Set password for new user rohan"

# Setup the drives
echo "LABEL=S0 /run/media/rohan/S0 auto nosuid,nodev,nofail,x-gvfs-show 0 0" | sudo tee -a /etc/fstab
echo "LABEL=BK /run/media/rohan/BK auto nosuid,nodev,nofail,x-gvfs-show 0 0" | sudo tee -a /etc/fstab
echo "LABEL=T0 /run/media/rohan/T0 auto nosuid,nodev,nofail,x-gvfs-show 0 0" | sudo tee -a /etc/fstab
echo "LABEL=T1 /run/media/rohan/T1 auto nosuid,nodev,nofail,x-gvfs-show 0 0" | sudo tee -a /etc/fstab

# MISC
echo "QT_QPA_PLATFORMTHEME=qt5ct" | tee -a /etc/environment
ln -sf /usr/bin/nvim /usr/bin/vi

# Disable NetworkManager-wait-online for faster SMB daemon startup
echo "Disabling NetworkManager-wait-online service"
systemctl disable NetworkManager-wait-online.service

echo "Setting up SMB server"
cp ./smb.conf /etc/samba/smb.conf
systemctl enable smb.service

echo "Setting up Python FTP servers"
cp ./pyftpd.service /etc/systemd/system/pyftpd.service
systemctl enable pyftpd

echo "Configuration done. You can now exit chroot."
