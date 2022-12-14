#! /bin/bash
# fix a steamos image to be more like a normal archlinux install. This is
# eidempotent, so if part of it fails you can just run it again after you fix
# the cause of the failure.

# act like a normal program
trap exit SIGINT SIGQUIT SIGTERM

# stop if any command fails
set -e

# pacman packages you want installed, edit this as desired
PACKS="base-devel gtksourceview4 gnumeric emacs syncthing gnome-keyring gst-plugins-bad gkrellm python-pip dotnet-sdk net-tools"

# list of packages not to mess with
SKIP="dracut"

# downloads from the steamos cloud are sometimes flaky
function retry_cmd {
	local tries=0
	while ! $@; do
		((tries++))
		if test $tries -gt 5; then
			echo "giving up, better luck next time"
			exit 1
		fi
	done
}

# unlock the fs
steamos-readonly disable

# update gpg keys so we can use pacman
pacman-key --init
pacman-key --populate archlinux
pacman-key --populate holo

# update the system, usually nothing, but just in case
pacman --overwrite '*' -Syu

# install pacutils so we can use paccheck to find packages with missing or
# changed files
pacman --overwrite '*' -S pacutils

# presumably for the 64 gig model valve deletes header files, man pages and the
# like from the image. So even though a package is "installed" it might be
# missing files we use paccheck to find packages with missing files and then
# reinstall them telling pacman to overwrite existing files. Once finished we
# should have a proper complement of header files. Otherwise it's neigh
# impossible to build anything on steamos.
REINSTALL=$(paccheck --md5sum --quiet 2>&1 | \
	grep -i "no such file or directory" | \
	awk '{print $2}' | \
	uniq | \
	sed -e 's/:$//' | \
	grep -vE $SKIP)

# fix the identified broken packages
retry_cmd pacman --overwrite '\*' -S "$REINSTALL"

# install user requested packages
retry_cmd pacman --overwrite '\*' -S "$PACKS"

# enable and start syncthing
sudo -u deck bash -c 'systemctl --user enable syncthing'
sudo -u deck bash -c 'systemctl --user start syncthing'

# install paru from aur
pacman -U ~deck/ext/paru-bin/paru-bin-1.11.1-1-x86_64.pkg.tar.zst

echo "steamos image setup success"

