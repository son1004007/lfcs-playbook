# Storage Cheatsheet

## LVM quick path
- PV: `pvcreate /dev/vdb`
- VG: `vgcreate vgdata /dev/vdb`
- LV: `lvcreate -n lvweb -L 5G vgdata`
- FS: `mkfs.xfs /dev/vgdata/lvweb`
- Mount: add UUID to `/etc/fstab` then `mount -a`
