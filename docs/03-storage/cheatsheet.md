# Storage Cheatsheet

## Partitions and filesystems
- List: `lsblk -f`, `blkid`
- Partition: `fdisk /dev/vdb` or `parted /dev/vdb`
- Make FS: `mkfs.xfs /dev/vdb1` or `mkfs.ext4 /dev/vdb1`
- Mount: `mount /dev/vdb1 /mnt`, persist via `/etc/fstab` (use UUID)

## LVM flow
- PV: `pvcreate /dev/vdb`
- VG: `vgcreate vgdata /dev/vdb`
- LV: `lvcreate -n lvweb -L 5G vgdata`
- FS: `mkfs.xfs /dev/vgdata/lvweb`
- Extend: `lvextend -r -L +2G /dev/vgdata/lvweb` (xfs_growfs auto with -r)

## Recovery
- ext*: `fsck -f /dev/vdb1`
- xfs: `xfs_repair /dev/vdb1` (unmounted)
