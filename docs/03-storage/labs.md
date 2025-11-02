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
