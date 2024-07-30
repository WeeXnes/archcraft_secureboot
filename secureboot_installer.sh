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

update_signature_vanilla(){
    echo signing [/boot/vmlinuz-linux]
    sudo sbsign --key /etc/refind.d/keys/refind_local.key --cert /etc/refind.d/keys/refind_local.crt --output /boot/vmlinuz-linux /boot/vmlinuz-linux
}
update_signature_cachyos(){
    echo signing [/boot/vmlinuz-linux-cachyos-eevdf]
    sudo sbsign --key /etc/refind.d/keys/refind_local.key --cert /etc/refind.d/keys/refind_local.crt --output /boot/vmlinuz-linux-cachyos-eevdf /boot/vmlinuz-linux-cachyos-eevdf
}

add_cachyos_to_refind_config(){
  echo this needs to be run as root/sudo
  echo Adding Menu Entry for Cachy Kernel to refind.conf
  echo "menuentry \"CachyOS\" {" >> /boot/efi/EFI/refind/refind.conf
  echo "        icon    /EFI/refind/themes/refind-ambience/icons/os_arch.png" >> /boot/efi/EFI/refind/refind.conf
  echo "        volume  \"ROOT\"" >> /boot/efi/EFI/refind/refind.conf
  echo "        loader  /boot/vmlinuz-linux-cachyos-eevdf" >> /boot/efi/EFI/refind/refind.conf
  echo "        initrd  /boot/initramfs-linux-cachyos-eevdf.img" >> /boot/efi/EFI/refind/refind.conf
  echo "        options \"root=/dev/nvme0n1p2 rw  quiet splash loglevel=3 udev.log_level=3 vt.global_cursor_default=0 splash lsm=landlock,lockdown,yama,integrity,apparmor,bpf\"" >> /boot/efi/EFI/refind/refind.conf
  echo "}" >> /boot/efi/EFI/refind/refind.conf
  echo done
  exit
}

install_theme(){
  sudo mkdir /boot/efi/EFI/refind/themes/
  sudo mkdir /boot/efi/EFI/refind/themes/refind-ambience/
  git clone https://github.com/lukechilds/refind-ambience.git
  sudo cp -r refind-ambience/* /boot/efi/EFI/refind/themes/refind-ambience/
  echo "include themes/refind-ambience/theme.conf" | sudo tee -a /boot/efi/EFI/refind/refind.conf > /dev/null
}



if [ $1 = "install" ]; then
  install_secureboot
  install_theme
elif [ $1 = "update" ]; then
  update_signature_vanilla
elif [ $1 = "update-cachy" ]; then
  update_signature_cachyos
elif [ $1 = "setup-cachy" ]; then
  add_cachyos_to_refind_config
else
  echo "unknown command, avaiable commands: install, update, update-cachy, setup-cachy"
fi