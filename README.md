This is a script to install quickly install secureboot on archcraft with either vanilla kernel or CachyOS kernel

**info: this script uses refind + shim-signed**

to use it, download the script and use the following commands:

### Install Secureboot
```shell
./secureboot_installer.sh install-secureboot
```
after rebooting you will be seeing the MOK Manager Screen, select "Enroll Key from Disk > [Your Disk] > EFI > refind > keys > refind > refind_local.cer" then confirm and reboot

### Update Secureboot
when the kernel gets updated, you need to resign it. use this command to do so
```shell
./secureboot_installer.sh update
# for cachyos (installation below):
./secureboot_installer.sh update-cachy
```

### Install refind-ambience theme
installs the refind-ambience theme for refind
```shell
./secureboot_installer.sh install-theme
```

## CachyOS
for use with CachyOS, execute the following commands
```shell
# installs secureboot like above
./secureboot_installer.sh install-secureboot

# adds the needed signature to the cachyos kernel
./secureboot_installer.sh update-cachy

# sets up a boot entry in refind for CachyOS (needed, default config for Cachy doesnt boot)
./secureboot_installer.sh setup-cachy
```