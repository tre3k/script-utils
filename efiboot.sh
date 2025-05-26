#!/usr/bin/env bash

# Простой скрипт формирующий стркочку для efibootmgr, чтобы загружать ядро
# в режиме EFI Stub без использования загрузчика
# Если передан параметр --exec то строчка выполнится

if [[ -z $SUFFIX ]]; then SUFFIX='-workpc'; fi
if [[ -z $LINUX_NAME ]]; then LINUX_NAME="ArchLinux"; fi
LABEL='"'${LINUX_NAME}${SUFFIX}' EFI stub"'

KERNEL_PATH='\\arch\\vmlinuz-linux'${SUFFIX}
INITRDS='\arch\intel-ucode.img \arch\initramfs-linux'${SUFFIX}'.img'

if [[ -z ${ESP_DISK} ]]; then ESP_DISK='/dev/sda'; fi
if [[ -z ${ESP_PART} ]]; then ESP_PART='1'; fi
if [[ -z ${ROOT_UUID} ]]; then ROOT_UUID='f4e983c2-595f-400e-9aee-56981fdc565e'; fi
if [[ -z ${SWAP_UUID} ]]; then SWAP_UUID='5beb6a95-a533-4234-ad57-2e80e4020820'; fi

for initrd in ${INITRDS}
do
    INITRD=${INITRD}' initrd='${initrd}
done

KERN_CMDLINE=${INITRD}' root=UUID='${ROOT_UUID}' rw resume=UUID='${SWAP_UUID}' consoleblank=600 splash quiet'

echo "label: "${LABEL}
echo "loader: "${KERNEL_PATH}
echo "cmdline: "${KERN_CMDLINE}
FULL_COMMAND=efibootmgr\ -c\ -L\ ${LABEL}\ -l\ ${KERNEL_PATH}\ -d\ ${ESP_DISK}\ -p\ ${ESP_PART}\ -u\ \'${KERN_CMDLINE}\'

echo -e "Full command: \033[1;96m"  # Cyan color
echo ${FULL_COMMAND}
echo -e "\033[0m"

if [[ "$1" == "--exec" ]];
then
	${FULL_COMMAND}
fi
