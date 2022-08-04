#! /bin/bash
# fix a steamos image to be more like a normal archlinux install. This is
# eidempotent, so if part of it fails you can just run it again after you fix
# the cause of the failure.

# act like a normal program
trap exit SIGINT SIGQUIT SIGTERM

# stop if any command fails
set -e

# dev packages you want installed, edit this as desired
DEVPACKS="base-devel gtksourceview4 gnumeric emacs syncthing gnome-keyring gst-plugins-bad gkrellm"

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

# update the system
pacman --overwrite '*' -Syu

# install pacutils so we can use paccheck to find packages with missing or
# changed files
pacman --overwrite '*' -S pacutils

# presumably for the 64 gig model they delete header files, man pages and the
# like from the image. So even though a package is installed it might be
# missing files we use paccheck to find packages with missing files and then
# reinstall them so we have a proper complement of header files and man pages.
# Otherwise it's neigh impossible to build anything on steamos.
REINSTALL=$(paccheck --md5sum --quiet 2>&1 | \
	grep -i "no such file or directory" | \
	awk '{print $2}' | \
	uniq | \
	sed -e 's/:$//' | \
	grep -vE $SKIP)

retry_cmd pacman --overwrite '*' -S $REINSTALL

# free space on the exceedingly tiny root partition
rm -rf /var/cache/pacman/pkg/*

retry_cmd pacman --overwrite '*' -S $DEVPACKS

# free space on the exceedingly tiny root partition
rm -rf /var/cache/pacman/pkg/*
