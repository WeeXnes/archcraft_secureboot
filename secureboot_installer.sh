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
    echo signing [/boot/vmlinuz-linux]
    sudo sbsign --key /etc/refind.d/keys/refind_local.key --cert /etc/refind.d/keys/refind_local.crt --output /boot/vmlinuz-linux-cachyos-eevdf /boot/vmlinuz-linux-cachyos-eevdf
}

add_cachyos_to_refind_config(){
  echo "menuentry \"CachyOS\" {" >> /boot/efi/EFI/refind/refind.conf
  echo "        icon    /EFI/refind/icons/os_arch.png" >> /boot/efi/EFI/refind/refind.conf
  echo "        volume  \"ROOT\"" >> /boot/efi/EFI/refind/refind.conf
  echo "        loader  /boot/vmlinuz-linux-cachyos-eevdf" >> /boot/efi/EFI/refind/refind.conf
  echo "        initrd  /boot/initramfs-linux-cachyos-eevdf.img" >> /boot/efi/EFI/refind/refind.conf
  echo "        options \"root=/dev/nvme0n1p2 rw  quiet splash loglevel=3 udev.log_level=3 vt.global_cursor_default=0 splash lsm=landlock,lockdown,yama,integrity,apparmor,bpf\"" >> /boot/efi/EFI/refind/refind.conf
  echo "}" >> /boot/efi/EFI/refind/refind.conf
}

install_theme(){
  sudo mkdir /boot/efi/EFI/refind/themes/
  sudo mkdir /boot/efi/EFI/refind/themes/refind-ambience/
  git clone https://github.com/lukechilds/refind-ambience.git
  sudo cp -r refind-ambience/* /boot/efi/EFI/refind/themes/refind-ambience/
  echo "include themes/refind-ambience/theme.conf" | sudo tee -a /boot/efi/EFI/refind/refind.conf > /dev/null
}


install_secureboot
install_theme
#update_signature_cachyos
add_cachyos_to_refind_config