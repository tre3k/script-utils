#!/usr/bin/env bash

# Простой скрипт формирующий стркочку для efibootmgr, чтобы загружать ядро
# в режиме EFI Stub без использования загрузчика
# Если передан параметр --exec то строчка выполнится

function findUUID() {
    lsblk -o UUID,MOUNTPOINT | while IFS= read -r line; do
	arr=()
	for col in $line; do
	    arr+=(${col})
	done
	if [[ "${arr[1]}" == "$1" ]]
	then
	    echo "${arr[0]}"
	    return 0
	fi
    done
    return -1
}


IFS='-' read -ra kernel_release <<< `uname -r`
if [[ -z $SUFFIX ]]; then SUFFIX=-${kernel_release[-1]}; fi
if [[ -z $LINUX_NAME ]]; then LINUX_NAME="ArchLinux"; fi
LABEL='"'${LINUX_NAME}${SUFFIX}' EFI stub"'

KERNEL_PATH='\\EFI\\arch\\vmlinuz-linux'${SUFFIX}
INITRDS='\EFI\arch\intel-ucode.img \EFI\arch\initramfs-linux'${SUFFIX}'.img'

# Нужно сделать тест существования файлов
#echo ${KERNEL_PATH} | sed 's/\\/\//g'

if [[ -z ${ESP_DISK} ]]; then ESP_DISK='/dev/sdb'; fi
if [[ -z ${ESP_PART} ]]; then ESP_PART='1'; fi
if [[ -z ${ROOT_UUID} ]]; then ROOT_UUID=$(findUUID "/"); fi
if [[ -z ${SWAP_UUID} ]]; then SWAP_UUID=$(findUUID "[SWAP]"); fi

for initrd in ${INITRDS}
do
    INITRD=${INITRD}' initrd='${initrd}
done

KERN_CMDLINE=${INITRD}' root=UUID='${ROOT_UUID}' rw resume=UUID='${SWAP_UUID}' consoleblank=600 splash quiet pcie_aspm=off pcie_port_pm=off'

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
