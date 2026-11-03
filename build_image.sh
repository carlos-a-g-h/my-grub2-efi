#!/usr/bin/bash

set -eux

GH_SHA="$1"
GH_REL_TAG="$2"

GH_CONST_REPO_OWNER="carlos-a-g-h"
GH_CONST_REPO_NAME="ubp-grub2-efi"

OUTDIR="dist"
FNAME="grub2.x86_64.efi"
OUTPATH="$OUTDIR"/"$FNAME"
GRUB_PREFIX="/grub2"

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

DETAILS="$OUTPATH"".details.txt"

URL_COMMIT="https://github.com/""$GH_CONST_REPO_OWNER""/""$GH_CONST_REPO_NAME""/commit/""$GH_SHA"
URL_RELEASE="https://github.com/""$GH_CONST_REPO_OWNER""/""$GH_CONST_REPO_NAME""/releases/tag/""$GH_REL_TAG"
URL_BINARY="https://github.com/""$GH_CONST_REPO_OWNER""/""$GH_CONST_REPO_NAME""/releases/download/""$GH_REL_TAG""/""$FNAME"

HASH_MD5=$(md5sum "$OUTPATH"|awk '{print $1}')
HASH_SHA256=$(sha256sum "$OUTPATH"|awk '{print $1}')

echo "DETAILS" > "$DETAILS"
echo "
URL_COMMIT $URL_COMMIT" >> "$DETAILS"
echo "
URL_RELEASE $URL_RELEASE" >> "$DETAILS"
echo "
URL_BINARY $URL_BINARY" >> "$DETAILS"
echo "
HASH_MD5 $HASH_MD5" >> "$DETAILS"
echo "
HASH_SHA256 $HASH_SHA256" >> "$DETAILS"
echo "
GRUB_MODULES ${MODULES[@]}" >> "$DETAILS"

# Display the contents of the output directory

find "$OUTDIR"
