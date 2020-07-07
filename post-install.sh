#! /bin/bash

# Post install script
echo "Orion Arch Config"

pacman -Rns vi vim

ln -sf /usr/bin/nvim /usr/bin/vi

# Set date time
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc

# Set locale to en_US.UTF-8 UTF-8
sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Set hostname
echo "orion" >> /etc/hostname
echo "127.0.1.1 orion.localdomain orion" >> /etc/hosts

# Generate initramfs
mkinitcpio -P

# Set root password
passwd

# Install bootloader
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# Create new user
useradd -m -G wheel,power,iput,storage,uucp,network -s /usr/bin/zsh rohan
echo "rohan ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
# sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers
echo "Set password for new user rohan"
passwd rohan

# Enable services
systemctl enable NetworkManager.service

# Set QT5 theme
echo "QT_QPA_PLATFORMTHEME=qt5ct" | sudo tee -a /etc/environment

echo "Configuration done. You can now exit chroot."
