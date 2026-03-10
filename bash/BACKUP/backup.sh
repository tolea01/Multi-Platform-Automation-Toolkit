#!/bin/bash

USE_DEFAULT=true
BACKUP_SOURCES=("/backup_archive.bz2" "/backup_file.txt" "/backup_folder")
FILES=()

check_backup_sorce() {
	local backup_sources="$1"

	for source in "$backup_sources[@]"; do
		if [ ! -e "$source" ]; then
			echo "Backup source/sources not exist"
		fi
	done	
 }

while [[ $# -gt 0 ]]; do
	case $1 in
		-f)
			USE_DEFAULT=false
			shift
			while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
				FILES+=("$1")
				shift
			done
			;;
		*)
			echo "Unknown option: $1"
			exit 1
			;;
	esac
done