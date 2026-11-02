#!/usr/bin/bash

set -eux

OUTDIR="dist"
FNAME="grub2.x86_64.efi"
OUTPATH="$OUTDIR"/"$FNAME"
GRUB_PREFIX="grub2"

# Create the output directory

mkdir -p "$OUTDIR"

# Create the EFI file

# NOTE:
# The modules listed on the first row are the most "recommended" ones according to several documentation sources

MODULES=(
	linux normal part_gpt part_msdos fat ext2 search search_fs_file
	luks luks2 lvm cryptodisk
	chain configfile
	search_fs_uuid search_label
	ntfs exfat btrfs xfs zfs
	efi_gop jpeg png font gfxterm gfxterm_background
)

grub-mkimage \
	--format="x86_64-efi" \
	--directory="/usr/lib/grub/x86_64-efi" \
	--output="$OUTPATH" \
	--prefix="$GRUB_PREFIX" \
	"${MODULES[@]}"

# Write some info about the EFI file

echo "${MODULES[@]}" > "$OUTPATH"".modules.txt"
sha256sum "$OUTPATH" > "$OUTPATH"".hash.sha256.txt"
md5sum "$OUTPATH" > "$OUTPATH"".hash.md5.txt"

# Display the contents of the output directory

find "$OUTDIR"
