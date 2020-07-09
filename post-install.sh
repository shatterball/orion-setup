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

# Install packages
pacman -Syy $(cat pkglist)

# Set root password
echo "Set root password"
passwd

# Install bootloader
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# Create new user
useradd -m -G wheel,power,audio,storage,network -s /usr/bin/zsh rohan
echo "rohan ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
echo "set-sink-port 0 analog-output-headphones" | sudo tee -a /etc/pulse/default.pa
echo "Set password for new user rohan"
passwd rohan

# Setup the drives
echo "LABEL=S0 /run/media/rohan/S0 auto nosuid,nodev,nofail,x-gvfs-show 0 0" | sudo tee -a /etc/fstab
echo "LABEL=ARCH_BK /run/media/rohan/ARCH_BK auto nosuid,nodev,nofail,x-gvfs-show 0 0" | sudo tee -a /etc/fstab
echo "LABEL=T0 /run/media/rohan/T0 auto nosuid,nodev,nofail,x-gvfs-show 0 0" | sudo tee -a /etc/fstab
echo "LABEL=T1 /run/media/rohan/T1 auto nosuid,nodev,nofail,x-gvfs-show 0 0" | sudo tee -a /etc/fstab

# Enable services
systemctl enable NetworkManager.service

# MISC
echo "QT_QPA_PLATFORMTHEME=qt5ct" | sudo tee -a /etc/environment
ln -sf /usr/bin/nvim /usr/bin/vi

echo "Configuration done. You can now exit chroot."
