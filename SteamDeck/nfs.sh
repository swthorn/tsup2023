
#!/usr/bin/env bash

# https://blogs.igalia.com/berto/2022/09/13/adding-software-to-the-steam-deck-with-systemd-sysext/

mkdir working-dir && cd working-dir
wget "https://archive.archlinux.org/packages/n/nfs-utils/nfs-utils-2.6.2-1-x86_64.pkg.tar.zst"
mkdir nfs
tar -C nfs -xaf nfs-*.tar.zst usr

source /etc/os-release

mkdir -p "nfs/usr/lib/extension-release.d"
echo -e "ID=steamos\nVERSION_ID=${VERSION_ID}" > "nfs/usr/lib/extension-release.d/extension-release.nfs"

mksquashfs nfs nfs.raw

mkdir -p /var/lib/extensions
sudo mv nfs.raw /var/lib/extensions

sudo systemd-sysext refresh

sudo rm -r working-dir
