#! /usr/bin/env bash

usage() {
cat << EOF
Usage $0 [OPTIONS...]

This script creates a jail based on a basejail

Options:
  -b basejail
  -f force (delete jail if exists)
  -l location
EOF
}

BASEJAIL=
LOCATION=
FORCE=0

while getopts "hfb:l:" OPTION
do
  case $OPTION in
    h)
      usage
      exit 0
      ;;
    f)
      FORCE=1
      ;;
    l)
      LOCATION=$OPTARG
      ;;
    b)
      BASEJAIL=$OPTARG
      ;;
  esac
done

# Check that all required parameters are set

if [ -z $BASEJAIL ]; then
  echo "No basejail path provided"
  exit 1
fi

if [ -z $LOCATION ]; then
  echo "No jail location provided"
  exit 1
fi

if [ -e $LOCATION ]; then
  if [[ $FORCE == 1 ]]; then
    echo "Jail location already exists, deleting"
    rm -rf $LOCATION
    if [[ $? != 0 ]]; then
      echo "Failed to delete old jail at ${LOCATION}"
      exit 1
    fi
  else
    echo "Jail location already exists, exiting."
    exit 1
  fi
fi

mkdir -p $LOCATION
MK_FOLDERS="usr"
COPY_FOLDERS="dev etc root mnt tmp var usr/local usr/games usr/obj usr/tests"
SYMLINK_FOLDERS="bin boot lib libexec rescue sbin sys usr/bin usr/include usr/lib usr/lib32 usr/libdata usr/libexec usr/ports usr/sbin usr/share usr/src"


mkdir -p "${LOCATION}/basejail"

for folder in $MK_FOLDERS; do
  mkdir -p "${LOCATION}/${folder}"
done

for folder in $COPY_FOLDERS; do
  ditto -Pr "${BASEJAIL}/${folder}" "${LOCATION}/${folder}"
done

for folder in $SYMLINK_FOLDERS; do
  echo $folder
  ln -s "/basejail/${folder}" "${LOCATION}/${folder}" 
done

