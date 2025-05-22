#!/usr/bin/env bash

# Простой скрипт формирующий стркочку для efibootmgr, чтобы загружать ядро
# в режиме EFI Stub без использования загрузчика

SUFFIX='-workpc'
LABEL='"ArchLinux'${SUFFIX}' EFI stub"'

KERNEL_PATH='\\arch\\vmlinuz-linux'${SUFFIX}
INITRDS='\arch\intel-ucode.img \arch\initramfs-linux'${SUFFIX}'.img'

ESP_DISK='/dev/sda'
ESP_PART='1'
ROOT_UUID='f4e983c2-595f-400e-9aee-56981fdc565e'
SWAP_UUID='5beb6a95-a533-4234-ad57-2e80e4020820'

for initrd in ${INITRDS}
do
    INITRD=${INITRD}' initrd='${initrd}
done

KERN_CMDLINE=${INITRD}' root=UUID='${ROOT_UUID}' rw resume=UUID='${SWAP_UUID}' consoleblank=600 splash quiet'

echo "label: "${LABEL}
echo "loader: "${KERNEL_PATH}
echo "cmdline: "${KERN_CMDLINE}
echo efibootmgr -c -L ${LABEL} -l ${KERNEL_PATH} -d ${ESP_DISK} -p ${ESP_PART} -u \'${KERN_CMDLINE}\'
