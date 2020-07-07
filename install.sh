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

cp -rfv mirrorlist /etc/pacman.d/
pacman -Syy

# Create and format partitions
cfdisk

# Format the partitions
mkfs.btrfs -L SYS /dev/sda1
mkswap -L SWAP /dev/sda2

# Set up time
timedatectl set-ntp true

# Initate pacman keyring
pacman-key --init
pacman-key --populate archlinux
pacman-key --refresh-keys

# Mount the partitions
mount /dev/sda1 /mnt
swapon /dev/sda2

# Install Arch Linux
echo "Installing Arch Linux..." 
pacstrap /mnt base base-devel linux-zen zsh grub intel-ucode xorg xorg-server dunst engrampa feh fzf gparted lxappearance mpv nemo neovim pavucontrol gnome-disk-utility qbittorrent python-pyftpdlib ranger qt5ct ripgrep uget ntfs-3g npm scrot zsh nodejs mlocate alsa-utils python3 pulseaudio curl rsync arc-icon-theme exa polkit-gnome noto-fonts noto-fonts-emoji qt5-styleplugins alacritty conky gvfs-mtp networkmanager network-manager-applet chromium bleachbit xorg-xsetroot picom bspwm sxhkd caja

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Copy post-install system cinfiguration script to new /root
cp -rfv post-install.sh /mnt/root
cp -rfv mirrorlist /mnt/etc/pacman.d/ 
chmod a+x /mnt/root/post-install.sh

# Chroot into new system
echo "After chrooting into newly installed OS, please run the post-install.sh by executing ./post-install.sh"
echo "Press any key to chroot..."
read tmpvar
arch-chroot /mnt /bin/bash

# Finish
echo "If post-install.sh was run succesfully, you will now have a fully working bootable Arch Linux system installed."
echo "The only thing left is to reboot into the new system."
echo "Press any key to reboot or Ctrl+C to cancel..."
read tmpvar
reboot
