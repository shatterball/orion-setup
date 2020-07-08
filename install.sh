#! /bin/bash

# This is Krushn's Arch Linux Installation Script.
# Visit krushndayshmookh.github.io/krushn-arch for instructions.

echo "Orion Arch"

# Set up network connection
read -p 'Are you connected to internet? [y/N]: ' neton
if ! [ $neton = 'y' ] && ! [ $neton = 'Y' ]
then 
    echo "Connect to internet to continue..."
    exit
fi

# Copy custom mirrorlist
cp -rfv mirrorlist /etc/pacman.d/
pacman -Syy

# Create and format partitions
cfdisk

# Format the partitions
mkfs.btrfs -L SYS /dev/sda1
mkswap -L SWAP /dev/sda2

# Set up time
timedatectl set-ntp true

# Mount the partitions
mount /dev/sda1 /mnt
swapon /dev/sda2

# Install Arch Linux
echo "Installing Arch Linux..." 
pacstrap /mnt base base-devel linux-zen zsh grub intel-ucode neovim

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Copy post-install system cinfiguration script to new /root
cp -rfv post-install.sh /mnt/root
cp -rfv pkglist /mnt/root
cp -rfv mirrorlist /mnt/etc/pacman.d/ 
chmod a+x /mnt/root/post-install.sh

# Chroot into new system
echo "After chrooting into newly installed OS, please run the post-install.sh by executing ./post-install.sh"
echo "Press any key to chroot..."
read tmpvar
arch-chroot /mnt /bin/bash
