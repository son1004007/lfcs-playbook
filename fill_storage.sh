#!/usr/bin/env bash
set -euo pipefail
mkdir -p docs/03-storage

cat > docs/03-storage/cheatsheet.md <<'DOC'
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
DOC

cat > docs/03-storage/labs.md <<'DOC'
# Storage Labs

## Lab 1: Create LVM and mount
1) `pvcreate /dev/vdb`
2) `vgcreate vgdata /dev/vdb`
3) `lvcreate -n lvapp -L 3G vgdata`
4) `mkfs.xfs /dev/vgdata/lvapp`
5) Create mountpoint and add to `/etc/fstab` using UUID, then `mount -a`
6) Verify: `df -h`, `lsblk`

## Lab 2: Grow LV and filesystem
1) `lvextend -L +1G /dev/vgdata/lvapp`
2) xfs: `xfs_growfs /dev/vgdata/lvapp`
3) Verify: `df -h`
DOC

echo "[OK] docs/03-storage files created."
