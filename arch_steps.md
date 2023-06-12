Rough outline of stuff I did on a thinkpad t530 with nvidia graphics
(though I only use the intel igpu on linux).

# Zero to CLI

Up to full disk encrypted root login with working wifi.

```sh
timedatectl set-ntp true

# Partitioning
# Assuming target disk is /dev/sda

gdisk /dev/sda
  p # print status
  o # create new GPT
    Y # confirm
  n # create EFI/boot partition
    - Partition number: default (1)
    - First sector: default (start of disk)
    - Last sector: +512M
    - Hex code or GUID: EF00
  n # create root parition
    - Partition number: default (2)
    - First sector: default (start of available space after partition 1)
    - Last sector: default (rest of disk)
    - Hex code or GUID: default (8300 - Linux filesystem)
  w # write changes to disk

# Now we should have:
#   /dev/sda1: EFI (fat32)
#   /dev/sda2: Linux filesystem
# Can confirm with `lsblk -fs`

# Setup LUKS encrypted partition on top of sda2:
cryptsetup -y -v luksFormat /dev/sda2
  confirm: YES
  enter & confirm passphrase
cryptsetup open /dev/sda2 cryptroot
  enter passphrase
mkfs.ext4 /dev/mapper/cryptroot
mount /dev/mapper/cryptroot /mnt
# optionally unmount & mount again to verify everything works:
#   umount /mnt
#   cryptsetup close cryptroot
#   cryptsetup open /dev/sda2 cryptroot
#   mount /dev/mapper/cryptroot /mnt

# Setup boot partition & mount:
mkfs.fat -F32 /dev/sda1
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

# Bootstrap
pacstrap /mnt base-devel linux linux-firmware efibootmgr vim tmux networkmanager-qt
# Or when on the gpd micro pc:
#   pacstrap /mnt base-devel linux linux-firmware linux-firmware-qlogic efibootmgr vim tmux iwd dhcpcd
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot to do further setups
arch-chroot /mnt
  ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
  hwclock --systohc
  echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
  locale-gen
  echo 'LANG=en_US.UTF-8' > /etc/locale.conf
  echo myhostname > /etc/hostname

  echo '127.0.0.1 localhost' >> /etc/hosts
  echo '::1 localhost' >> /etc/hosts
  echo '127.0.1.1 harry' >> /etc/hosts

  systemctl enable NetworkManager
  # Or when on the gpd micro pc:
  #   systemctl enable iwd
  #   systemctl enable dhcpcd

  vim /etc/mkinitcpio.conf
    HOOKS=(base *udev* autodetect *keyboard* consolefont modconf block *encrypt* filesystems fsck) 
  mkinitcpio -P
  efibootmgr --verbose --disk /dev/sda --part 1 --create --label "Arch Linux" \
    --loader /vmlinuz-linux \
    --unicode 'cryptdevice=UUID=uuid_of_dev_sda2:cryptroot root=/dev/mapper/cryptroot rw initrd=\intel-ucode.img initrd=\initramfs-linux.img'
  # you can find uuid_of_dev_sda2 with `ls -l /dev/disk/by-uuid`
  pacman -S intel-ucode
  passwd
  exit

umount -R /mnt
reboot


# login as root, use nmtui to connect to wifi, profit.
```

# CLI to GUI

```sh
# Main user
pacman -Syu fish git opendoas
useradd -m -s `which fish` nhanb
passwd nhanb
echo 'permit nopass nhanb as root' > /etc/doas.conf

# Xorg, SDDM, KDE
pacman -Syu xorg-server xorg-apps xf86-video-intel mesa \
  sddm sddm-kcm \
  plasma-meta kde-applications-meta
vim /etc/sddm.conf.d/autologin.conf :
  [Autologin]
  User=john
  Session=plasma.desktop
```

# Fluff

```sh
# These fonts cover sans-serif, serif, lots of monospace/programming fonts,
# cjk, emoji and kaomoji
doas pacman -S ttf-dejavu ttf-croscore ttf-ibm-plex ttf-liberation \
  ttf-fira-mono ttf-hack ttf-inconsolata ttf-jetbrains-mono \
  adobe-source-code-pro-fonts adobe-source-sans-pro-fonts \
  adobe-source-serif-pro-fonts adobe-source-han-sans-otc-fonts \
  adobe-source-han-serif-otc-fonts noto-fonts-emoji gnu-free-fonts \
  ttf-arphic-uming ttf-indic-otf ttf-ubuntu-font-family
```
