# LFCS Playbook

LFCS(Linux Foundation Certified Sysadmin) 준비를 위한 치트시트, 랩, 스크립트를 정리한 저장소입니다.

## 구성
- **docs/**: 도메인별 이론 요약 & 명령어 치트시트, 실습 가이드
- **scripts/**: 반복 실습용 스크립트 (shellcheck 통과)
- **labs/**: VM, 컨테이너, 네트워킹 등 시나리오형 실습
- **.github/workflows/**: CI (shellcheck, markdownlint)


https://training.linuxfoundation.org/certification/linux-foundation-certified-sysadmin-lfcs/
아래는 **Debian/Ubuntu 계열** 기준으로 LFCS 도메인별 핵심 개념과 실무 명령어/설정 경로를 **시험 친화적으로** 정리한 "텍스트 치트시트"입니다. (Ubuntu 22.04/24.04, systemd, netplan, nftables/ufw 기준)

---

# Operations & Deployment (25%)

## 커널 파라미터 (일시/영구)

* 일시: `sysctl net.ipv4.ip_forward=1` , 확인: `sysctl net.ipv4.ip_forward`
* 영구: `/etc/sysctl.conf` 또는 `/etc/sysctl.d/99-custom.conf` 에 `net.ipv4.ip_forward=1` 후 `sysctl -p`
* 모듈 로드/블랙리스트: 즉시 `modprobe br_netfilter` / 영구 `/etc/modules-load.d/custom.conf`; 블랙리스트 `/etc/modprobe.d/blacklist.conf`

## 프로세스/서비스 진단

* 프로세스: `ps aux | grep NAME` , `top`/`htop` , `pidof sshd`, `pstack <pid>`(gdb), `strace -p <pid>`
* 서비스(systemd): `systemctl status nginx` / `start|stop|restart|enable|disable` / `journalctl -u nginx -b`
* 포트/소켓: `ss -tulpn` , `lsof -i :443`

## 작업 스케줄

* **cron**: `crontab -e` , 시스템 크론 `/etc/crontab`, `/etc/cron.d/`
  형식: `MIN HOUR DOM MON DOW CMD`
* **systemd timer**: 서비스 `foo.service` + 타이머 `foo.timer`
  `systemctl enable --now foo.timer` , 상태 `systemctl list-timers`

## 패키지/리포지터리 관리

* APT 캐시/검색/설치: `sudo apt update && sudo apt upgrade -y` , `apt search htop` , `apt show htop` , `apt install htop`
* 서명키/리포: `/etc/apt/sources.list` , `/etc/apt/sources.list.d/*.list` , 키 관리 `apt-key`(구형) 대신 keyring 파일 사용

## 장애 복구(부팅/파일시스템)

* GRUB 복구(라이브 환경): `mount /dev/sdXn /mnt && mount --bind /dev /mnt/dev && mount --bind /proc /mnt/proc && mount --bind /sys /mnt/sys && chroot /mnt && update-grub && grub-install /dev/sdX`
* fsck: `fsck -f /dev/sdXn` (필요 시 단일모드/라이브에서)
* 저널 확인: `journalctl -xb` , 커널 메시지 `dmesg -T`

## 가상머신(libvirt)

* 설치: `apt install qemu-kvm libvirt-daemon-system virtinst virt-manager`
* 서비스: `systemctl status libvirtd`
* 브리지 기본: `virsh net-list --all`, `virsh net-start default`
* VM 생성: `virt-install --name vm1 --ram 2048 --disk size=20 --cdrom /iso/ubuntu.iso --network network=default`

## 컨테이너 엔진

* Docker: `apt install docker.io` , 서비스 `systemctl enable --now docker`
  이미지/컨테이너: `docker pull nginx`, `docker run -d -p 8080:80 --name web nginx`, `docker ps -a`, `docker logs web`, `docker exec -it web bash`
* Podman(루트리스 가능): `apt install podman` , `podman run …`

## MAC(Selinux)

> Ubuntu는 기본 **AppArmor** 사용. LFCS 대비용으로 SELinux도 정리.

* 상태: `sestatus` , 모드 변경(일시): `setenforce 0|1`
* 컨텍스트 보기/복구: `ls -Z`, `restorecon -Rv /path`
* 정책/포트/파일컨텍스트: `semanage boolean -l`, `semanage port -l`, `semanage fcontext -a -t httpd_sys_content_t '/srv/www(/.*)?'`
* 라벨 적용: `restorecon -R /srv/www`

---

# Networking (25%)

## IPv4/IPv6, 호스트네임/해결

* 호스트네임: `hostnamectl set-hostname srv1`
* 로컬 해석: `/etc/hosts`
* Netplan(서버 표준): `/etc/netplan/*.yaml` 편집 → `netplan try` → `netplan apply`
  예)

  ```yaml
  network:
    version: 2
    ethernets:
      ens160:
        addresses: [192.168.1.10/24]
        gateway4: 192.168.1.1
        nameservers:
          addresses: [1.1.1.1,8.8.8.8]
  ```

## 시간 동기화

* 기본 timesyncd: `timedatectl`, `systemctl status systemd-timesyncd`
* NTP 서버 지정(chrony 선호): `apt install chrony` → `/etc/chrony/chrony.conf` 에 `pool …` → `systemctl enable --now chrony` → `chronyc sources -v`

## 네트워크 모니터링/트러블슈팅

* 링크/라우팅: `ip a`, `ip r`, `ip -6 r`
* DNS 확인: `resolvectl query example.com`
* 연결: `ping`, `ping6`, `traceroute`, `mtr`, `curl -v http://…`

## OpenSSH 서버/클라이언트

* 서버 설치: `apt install openssh-server` , 상태 `systemctl status ssh`
* 설정: `/etc/ssh/sshd_config` (예: `PasswordAuthentication no`, `PermitRootLogin prohibit-password`) → `systemctl reload ssh`
* 클라이언트: `ssh -i key user@host` , 전달포트: `ssh -L 8080:127.0.0.1:80 user@host`

## 패킷필터/포트포워딩/NAT

* **UFW(쉬운 인터페이스)**:
  `ufw status` , `ufw allow 22/tcp` , `ufw enable` , 특정 IP 허용 `ufw allow from 10.0.0.0/24 to any port 22`
* **nftables(권장 백엔드)**: 규칙셋 `/etc/nftables.conf` , `nft list ruleset`, `systemctl enable --now nftables`
* IP 포워딩/NAT 예(nft):

  ```
  sysctl -w net.ipv4.ip_forward=1
  table ip nat {
    chain postrouting {
      type nat hook postrouting priority 100; policy accept;
      oif "eth0" masquerade
    }
  }
  ```

## 정적 라우팅

* 일시: `ip route add 10.10.0.0/16 via 192.168.1.254`
* 영구: netplan `routes:` 또는 `/etc/systemd/network/*.network`(systemd-networkd 사용 시)

## 브리지/본딩

* 브리지(netplan):

  ```yaml
  bridges:
    br0:
      interfaces: [ens160]
      addresses: [192.168.1.50/24]
      gateway4: 192.168.1.1
  ```
* 본딩(예: mode 802.3ad):

  ```yaml
  bonds:
    bond0:
      interfaces: [ens160,ens161]
      parameters:
        mode: 802.3ad
        mii-monitor-interval: 100
  ```

## 리버스 프록시/로드밸런서

* Nginx(리버스 프록시):

  ```
  server {
    listen 80;
    location / { proxy_pass http://127.0.0.1:8080; }
  }
  ```
* HAProxy(로드밸런서):

  ```
  frontend fe_http
    bind *:80
    default_backend be_app
  backend be_app
    balance roundrobin
    server app1 10.0.0.11:8080 check
    server app2 10.0.0.12:8080 check
  ```

---

# Storage (20%)

## LVM

* 준비: `fdisk /dev/sdb` → 타입 8e(구형) 또는 그냥 파티션 생성
* PV/VG/LV:
  `pvcreate /dev/sdb1`
  `vgcreate vgdata /dev/sdb1`
  `lvcreate -n lvlogs -L 10G vgdata`
* 파일시스템/마운트:
  `mkfs.ext4 /dev/vgdata/lvlogs`
  `mkdir -p /logs`
  `/etc/fstab`에 `UUID=... /logs ext4 defaults 0 2` → `mount -a`
* 확장: `lvextend -r -L +5G /dev/vgdata/lvlogs` (`-r`는 온라인 리사이즈)

## 가상 파일시스템

* 마운트: `mount -t proc proc /proc` , `mount -t tmpfs tmpfs /mnt/tmp`
* 자동마운트: `/etc/fstab` (옵션 `noatime`, `discard` 등)

## 파일시스템 생성/점검/튜닝

* 생성: `mkfs.ext4 /dev/sdb1` , `mkfs.xfs /dev/sdb1`
* 점검: `fsck -f /dev/sdb1` (마운트 해제 상태)
* 튜닝: `tune2fs -l /dev/sdb1` , 마운트옵션 `/etc/fstab`

## 원격FS/NBD

* NFS 클라: `apt install nfs-common` → `mount -t nfs server:/export /mnt`
  영구: `/etc/fstab` 예) `server:/export /mnt nfs defaults,_netdev 0 0`
* SMB: `apt install cifs-utils` → `mount -t cifs //srv/share /mnt -o username=...`
* iSCSI: `apt install open-iscsi` → `iscsiadm -m discovery -t st -p <targetIP>` → `iscsiadm -m node --login`
* NBD: `apt install nbd-client` → `modprobe nbd` → `nbd-client <server> <dev>`

## 스왑

* 스왑파일: `fallocate -l 4G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile`
  `/etc/fstab`에 `/swapfile swap swap defaults 0 0`
* 스왑 우선순위: `swapon -s`, `sysctl vm.swappiness=10`

## automounter

* `apt install autofs`
  `/etc/auto.master` 예) `/- /etc/auto.direct`
  `/etc/auto.direct` 예) `/mnt/shared -fstype=nfs,rw server:/export/shared`
  `systemctl restart autofs`

## 스토리지 성능 모니터링

* `iostat -xz 1`(sysstat), `iotop`, `dstat`, `vmstat 1`, `nfsiostat`, `mountstats`

---

# Essential Commands (20%)

## Git 기본

* 설정: `git config --global user.name "You"`, `git config --global user.email you@ex.com`
* 흐름: `git init` → `git add .` → `git commit -m "msg"` → `git remote add origin URL` → `git push -u origin main`
* 브랜치/병합: `git switch -c feature` , `git merge feature`

## 서비스 생성/설정/문제해결

* 유닛 생성: `/etc/systemd/system/myapp.service`

  ```
  [Unit]
  Description=My App
  After=network.target

  [Service]
  ExecStart=/usr/local/bin/myapp
  User=app
  Restart=on-failure

  [Install]
  WantedBy=multi-user.target
  ```

  `systemctl daemon-reload && systemctl enable --now myapp`
* 문제: `journalctl -u myapp -e`

## 시스템 성능/서비스 모니터링

* CPU/메모리: `top`, `free -h`, `vmstat 1`, `sar -u 1 5`
* 서비스 가용성: `systemctl`, `ss -lntp`, 헬스체크 `curl -f http://127.0.0.1:8080/health || echo FAIL`

## 애플리케이션 제약 파악

* 리미트: `ulimit -a`, 서비스 단위 `LimitNOFILE=65535`
* 권한/컨텍스트: `namei -l /path`, `stat`, (SELinux 시) `ls -Z`

## 디스크 공간 문제 해결

* 어디가 큰가: `df -h`, `du -xh --max-depth=1 / | sort -h | tail`
* 삭제 전 점검: 로그 로테이트 `logrotate -d /etc/logrotate.conf`
* 고아 인덱스/저널: `journalctl --vacuum-size=200M`

## SSL 인증서

* 생성(자체서명): `openssl req -new -newkey rsa:4096 -nodes -keyout key.pem -x509 -days 365 -out cert.pem`
* 체인 확인: `openssl s_client -connect host:443 -servername host -showcerts`
* 포맷 변환: `openssl x509 -in cert.pem -outform der -out cert.der`

---

# Users & Groups (10%)

## 로컬 사용자/그룹

* 사용자: `adduser alice` 또는 `useradd -m -s /bin/bash alice` , 비번 `passwd alice`
* 그룹: `groupadd dev`, `usermod -aG dev alice`, `id alice`
* 삭제: `userdel -r alice`, `groupdel dev`

## 환경 프로파일

* 개인 셸: `~/.bashrc`, `~/.profile`
* 시스템 전역: `/etc/profile`, `/etc/bash.bashrc`, `/etc/environment`
* systemd 서비스 환경: `Environment="X=1"` 또는 `EnvironmentFile=/etc/default/myapp`

## 사용자 리소스 제한

* PAM 제한: `/etc/security/limits.conf` 예)
  `alice hard nofile 65535`
  적용 대상 PAM 파일: `/etc/pam.d/common-session*` 에 `pam_limits.so`
* 런타임 확인: `ulimit -n`

## ACL

* 파일 ACL: `setfacl -m u:alice:rwx /data`, 디폴트 ACL: `setfacl -m d:u:alice:rwx /data`
* 조회: `getfacl /data`
* 주의: 마운트옵션 `acl` 필요할 수 있음

## LDAP 연동(개요)

* 클라 패키지: `apt install libnss-ldapd libpam-ldapd` 또는 SSSD(`sssd libpam-sss libnss-sss`)
* NSS/PAM 설정: `/etc/nsswitch.conf` 에 `passwd: files systemd ldap` 또는 `... sss`
* SSSD 예: `/etc/sssd/sssd.conf` 편집 → `chmod 600` → `systemctl enable --now sssd`
* 홈 디렉터리 자동 생성: `/etc/pam.d/common-session` 에 `pam_mkhomedir.so` 추가

---

## 필요시 빠른 확인 명령 모음

* 시스템 정보: `lsb_release -a`, `uname -r`, `cat /etc/os-release`
* 런레벨/타겟: `systemctl get-default`, `systemctl set-default multi-user.target`
* 부팅 순서/서비스 의존: `systemd-analyze blame`, `systemd-analyze critical-chain`
* 네임서비스: `getent passwd alice`, `getent hosts example.com`

---



## 디렉터리 구조

```
lfcs-playbook/
├─ README.md
├─ LICENSE
├─ CONTRIBUTING.md
├─ Makefile
├─ .editorconfig
├─ .gitignore
├─ .markdownlint.json
├─ .github/
│  ├─ workflows/
│  │  └─ ci.yml                 # shellcheck, markdownlint 자동 검사
│  └─ ISSUE_TEMPLATE/
│     ├─ bug_report.md
│     └─ checklist.md
├─ docs/
│  ├─ 00-overall/
│  │  ├─ study-plan.md          # 주차별 학습 계획
│  │  └─ exam-day-checklist.md  # 시험 당일 체크리스트
│  ├─ 01-operations/
│  │  ├─ cheatsheet.md
│  │  └─ labs.md
│  ├─ 02-networking/
│  │  ├─ cheatsheet.md
│  │  └─ labs.md
│  ├─ 03-storage/
│  │  ├─ cheatsheet.md
│  │  └─ labs.md
│  ├─ 04-users-process/
│  │  ├─ cheatsheet.md          # 사용자/권한/프로세스/서비스
│  │  └─ labs.md
│  └─ 05-security/
│     ├─ cheatsheet.md          # SELinux/MAC 등
│     └─ labs.md
├─ scripts/
│  ├─ net/
│  │  ├─ ifcfg_examples/        # Systemd-networkd or Netplan 예시도 가능
│  │  └─ sshtest.sh
│  ├─ storage/
│  │  ├─ lvm_create.sh
│  │  └─ fs_repair_demo.sh
│  ├─ ops/
│  │  ├─ cron_sample.sh
│  │  └─ service_health.sh
│  └─ security/
│     └─ selinux_demo.sh
├─ labs/
│  ├─ vm/
│  │  ├─ cloud-init/            # 연습용 VM 자동설정 파일
│  │  └─ libvirt/               # libvirt xml 예시
│  ├─ containers/
│  │  ├─ podman/
│  │  └─ docker/
│  └─ answers/                  # 랩 수행 기록/풀이
└─ .devcontainer/
   ├─ devcontainer.json
   └─ Dockerfile
```
