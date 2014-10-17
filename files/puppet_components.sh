#! /usr/bin/env bash

usage() {
cat << EOF

Usage: $0 [OPTIONS...]
    
This scripts downloads and installs puppet, facter, and hiera
Options:
  -r FreeBSD release (default: current release)
  -a architecture (default: current architecture)
  -d download location (default: /usr/local/puppet-components)
  -f force (delete install files if exists)
  -r redownload (force redownload files)
  -h display this help
EOF
}

DOWNLOAD_LOCATION=/usr/local/puppet-components
BASE_DOWNLOAD_URL="https://downloads.puppetlabs.com"

PUPPET_DOWNLOAD_URL="${BASE_DOWNLOAD_URL}/puppet/puppet-3.7.1.tar.gz"
PUPPET_DOWNLOAD_LOCATION="${DOWNLOAD_LOCATION}/puppet-3.7.1.tar.gz"
PUPPET_INSTALL_LOCATION="${DOWNLOAD_LOCATION}/puppet/"


FACTER_DOWNLOAD_URL="${BASE_DOWNLOAD_URL}/facter/facter-2.2.0.tar.gz"
HIERA_DOWNLOAD_URL="${BASE_DOWNLOAD_URL}/hiera/hiera-1.3.4.tar.gz"
FACTER_INSTALL_LOCATION="${DOWNLOAD_LOCATION}facter"
HIERA_INSTALL_LOCATION="${DOWNLOAD_LOCATION}hiere"



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

### Check is download folder exists

if [ -e $DOWNLOAD_LOCATION ]; then
	echo "Dir already exists...skipping."
else
	mkdir -p $DOWNLOAD_LOCATION
fi

### Download, untar, install puppet
	
    for f in $PUPPET_DOWNLOAD_URL; do
    TARGET_LOCATION="${PUPPET_DOWNLOAD_LOCATION}"
    DOWNLOAD_URL="${PUPPET_DOWNLOAD_URL}"

    if [ -f $TARGET_LOCATION ]; then
        if [[ $REDOWNLOAD == 1 ]]; then
            echo "${TARGET_LOCATION} already exists, but force redownload requested. Deleting"
            rm -rf $TARGET_LOCATION
        else
            echo "${TARGET_LOCATION} already exists, skipping"
            continue   
        fi 
    fi

    echo "Downloading $f from $BASE_DOWNLOAD_URL"
    curl -o $TARGET_LOCATION $PUPPET_DOWNLOAD_URL

    if [[ $? != 0 ]]; then
        echo "Failed to download $f"
        exit 1
    fi
 done
    
if [ -e $PUPPET_INSTALL_LOCATION ]; then
    echo "Uncompressing $f"
    tar xfz "$TARGET_LOCATION" -C $PUPPET_INSTALL_LOCATION
else
    echo "Creating dir ${PUPPET_INSTALL_LOCATION}"
    mkdir -p $PUPPET_INSTALL_LOCATION
    tar xfz "$TARGET_LOCATION" -C $PUPPET_INSTALL_LOCATION
fi






