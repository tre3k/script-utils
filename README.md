# sript-utils

Разнообразные утилиты для облегчения жизни

[efiboot.sh ](##efiboot.sh)

[share-inet.sh](##share-inet.sh)

[clearcache.sh](##clearcache.sh)

## efiboot.sh
 Просто выводит строчку efibootmgr <и всякие аргументы заданные в
 efiboot.sh>, чтобы избежать опечаток.

## share-inet.sh
 Расшаривает сеть с одного интерфейса `$FROM_IFACE` на другой
 `$TO_IFACE`.

## clearcache.sh
 Очищает кэш оперативной памяти записывая `3` в
 `/proc/sys/vm/drop_caches` и чистит содержимое свап разела путем его
 отключения/подключения.
