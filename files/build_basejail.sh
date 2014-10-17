#! /usr/bin/env bash

usage() {
cat << EOF

Usage: $0 [OPTIONS...]
    
This scripts creates a 'basejail' FreeBSD Install

Options:
  -r FreeBSD release (default: current release)
  -a architecture (default: current architecture)
  -d download location (default: /usr/local/freebsd-dist)
  -b basejail location (default: /usr/local/jails/basejail)
  -f force (delete basejail if exists)
  -r redownload (force redownload files)
  -h display this help
EOF
}

ARCH=`uname -p`
RELEASE=`uname -r`
DOWNLOAD_LOCATION=/usr/local/freebsd-dist
BASEJAIL_LOCATION=/usr/local/jails/basejail
REDOWNLOAD=0
FORCE=0

while getopts "hrfa:d:b:" OPTION
do
    case $OPTION in
        h)
            usage
            exit 0
            ;;
        a)
            ARCH=$OPTARG
            ;;
        d)
            DOWNLOAD_LOCATION=$OPTARG
            ;;
        b)
            BASEJAIL_LOCATION=$OPTARG
            ;;
        r)
            REDOWNLOAD=1
            ;;
        f)
            FORCE=1
    esac
done

INSTALL_FILES="base.txz lib32.txz doc.txz ports.txz src.txz"

BASE_DOWNLOAD_URL="ftp://ftp.FreeBSD.org/pub/FreeBSD/releases/${ARCH}/${ARCH}/${RELEASE}"

### Download

for f in $INSTALL_FILES; do
    TARGET_LOCATION="${DOWNLOAD_LOCATION}/${f}"
    DOWNLOAD_URL="${BASE_DOWNLOAD_URL}/$f"

    if [ -f $TARGET_LOCATION ]; then
        if [[ $REDOWNLOAD == 1 ]]; then
            echo "${TARGET_LOCATION} already exists, but force redownload requested. Deleting"
            rm -rf $TARGET_LOCATION
        else
            echo "${TARGET_LOCATION} already exists, skipping"
            continue   
        fi 
    fi

    echo "Downloading $f from $DOWNLOAD_URL"
    ftp -o $TARGET_LOCATION $DOWNLOAD_URL

    if [[ $? != 0 ]]; then
        echo "Failed to download $f"
        exit 1
    fi
done

### Build basejail

if [ -e $BASEJAIL_LOCATION ]; then
    if [[ $FORCE == 1 ]]; then
        echo "Basejail already exists, but force rebuild requested. Deleting."

        chflags -R noschg $BASEJAIL_LOCATION

        rm -rf $BASEJAIL_LOCATION   
        if [[ $? != 0 ]]; then
            echo "Failed to delete old basejail"
            exit 1    
        fi
    else
        echo "Basejail already exists, quitting. Run again with -f to force a rebuild"
        exit 1
    fi
fi

mkdir -p $BASEJAIL_LOCATION

for f in $INSTALL_FILES; do
    echo "Uncompressing $f"
    tar xfz "${DOWNLOAD_LOCATION}/$f" -C $BASEJAIL_LOCATION
done

### Fix the ldconfig

chroot $BASEJAIL_LOCATION $BASEJAIL_LOCATION/etc/rc.d/ldconfig start

### Download and install puppet


