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

if [[ -z ${ESP_DISK} ]]; then ESP_DISK='/dev/sdb'; fi
if [[ -z ${ESP_PART} ]]; then ESP_PART='1'; fi
if [[ -z ${ROOT_UUID} ]]; then ROOT_UUID=$(findUUID "/"); fi
if [[ -z ${SWAP_UUID} ]]; then SWAP_UUID=$(findUUID "[SWAP]"); fi

# Тест существования файлов
tmp_mount_path='/tmp/'`uuidgen`
sudo mkdir -p $tmp_mount_path
sudo mount ${ESP_DISK}${ESP_PART} ${tmp_mount_path}

test_paths=($(echo ${tmp_mount_path}${KERNEL_PATH} | sed 's/\\/\//g'))
for initrd in ${INITRDS}; do
    test_paths+=($(echo ${tmp_mount_path}${initrd} | sed 's/\\/\//g'))
done

for test_path in ${test_paths[@]}; do
    if [[ -f ${test_path} ]]; then
	echo -e "\033[1mFOUND: \033[0m" ${test_path}
    else
	echo -e "\033[33m\033[1mWARNING!!!\033[0m Not found:" ${test_path}
    fi
done
sudo umount ${tmp_mount_path}
sudo rm -rf ${tmp_mount_path}

echo -e "\033[1mroot UUID: \033[0m"${ROOT_UUID}
echo -e "\033[1mswap UUID: \033[0m"${SWAP_UUID}

for initrd in ${INITRDS}
do
    INITRD=${INITRD}' initrd='${initrd}
done

KERN_CMDLINE=${INITRD}' root=UUID='${ROOT_UUID}' rw resume=UUID='${SWAP_UUID}' consoleblank=600 splash quiet pcie_aspm=off pcie_port_pm=off'

echo -e "\033[1mlabel:\033[0m "${LABEL}
echo -e "\033[1mloader: \033[0m"${KERNEL_PATH}
echo -e "\033[1mcmdline: \033[0m"
echo ${KERN_CMDLINE}
FULL_COMMAND=efibootmgr\ -c\ -L\ ${LABEL}\ -l\ ${KERNEL_PATH}\ -d\ ${ESP_DISK}\ -p\ ${ESP_PART}\ -u\ \'${KERN_CMDLINE}\'

echo -e "\033[1mFull command: \033[1;96m"  # Cyan color
echo ${FULL_COMMAND}
echo -e "\033[0m"

if [[ "$1" == "--exec" ]];
then
	sudo ${FULL_COMMAND}
fi
