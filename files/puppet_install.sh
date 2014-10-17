PORTS_DIR=/usr/ports
BASE_JAIL_INSTALL_LOCATION=/usr/local/jails/basejail/usr/

echo "Updating ports tree (Assuming you have ran portsnap extract already"
portsnap fetch update

echo "Installing puppet"
cd $PORTS_DIR/sysutils/puppet
make DESTDIR=$BASE_JAIL_INSTALL_LOCATION PREFIX=/usr install