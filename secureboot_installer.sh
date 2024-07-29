#!/bin/bash

install_secureboot(){
  yay -S shim-signed
  read -p "[shim-signed] installed, press any key to continue ..."
  sudo pacman -S sbsigntools efitools refind
  read -p "[sbsigntools, efitools, refind] installed, press any key to continue ..."
  sudo refind-install --shim /usr/share/shim-signed/shimx64.efi --localkeys
  read -p "[refind-install] executed, press any key to continue ..."
  echo signing [/boot/efi/EFI/archcraft/grubx64.efi]
  sudo sbsign --key /etc/refind.d/keys/refind_local.key --cert /etc/refind.d/keys/refind_local.crt --output /boot/efi/EFI/archcraft/grubx64.efi /boot/efi/EFI/archcraft/grubx64.efi
  echo signing [/boot/efi/EFI/boot/bootx64.efi]
  sudo sbsign --key /etc/refind.d/keys/refind_local.key --cert /etc/refind.d/keys/refind_local.crt --output /boot/efi/EFI/boot/bootx64.efi /boot/efi/EFI/boot/bootx64.efi
  echo signing [/boot/vmlinuz-linux]
  sudo sbsign --key /etc/refind.d/keys/refind_local.key --cert /etc/refind.d/keys/refind_local.crt --output /boot/vmlinuz-linux /boot/vmlinuz-linux

}

install_theme(){
  sudo mkdir /boot/efi/EFI/refind/themes/
  sudo mkdir /boot/efi/EFI/refind/themes/refind-ambience/
  git clone https://github.com/lukechilds/refind-ambience.git
  sudo cp -r refind-ambience/* /boot/efi/EFI/refind/themes/refind-ambience/
  echo "include themes/refind-ambience/theme.conf" | sudo tee -a /boot/efi/EFI/refind/refind.conf > /dev/null
}

install_theme