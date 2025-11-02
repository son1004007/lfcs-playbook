# Users & Processes Cheatsheet

## Users/Groups
- Add user: `useradd -m alice`
- Password: `passwd alice`
- Group add: `groupadd devs`
- Add to group: `usermod -aG devs alice`
- Delete: `userdel -r alice`

## Sudoers
- Add sudo rights: `usermod -aG sudo alice` (Debian/Ubuntu) or `wheel` (RHEL)
- Edit file: `visudo`

## Processes
- List: `ps aux --sort=-%mem | head`
- Nice: `nice -n 10`, `renice`
- Kill: `kill -TERM <pid>`, `kill -9 <pid>` (last resort)
- Top: `top` or `htop` (if installed)
