# don't even try if we aren't root
if [ ! $(whoami) == 'root' ];
then
	echo 'ERROR: you need to be root'
	exit 1
fi


# Set user, group and permission for specified file/dir, recursively.
# @param	target file
# @param	user
# @param	group
# @param	chmod permissions
function set_permissions {
	file=$1
	user=$2
	group=$3
	permissions=$4

	chown -R $user $file
	chgrp -R $group $file
	chmod -R $permissions $file
}


# load configuration
. conf.sh


# create consul user
useradd $CONSUL_USER

# download, unarchive and copy consul to proper path
echo 'Downloading and copying Consul...'
wget "https://releases.hashicorp.com/consul/0.7.0/$CONSUL_ARCHIVE"
unzip $CONSUL_ARCHIVE -d $CONSUL_PATH
set_permissions "$CONSUL_PATH/consul" $CONSUL_USER $CONSUL_USER '500'

# main configuration file
echo 'Creating configuration file...'
mkdir $CONSUL_CONF_FILE
set_permissions $CONSUL_CONF_FILE $CONSUL_USER $CONSUL_USER '500'
# configuration directory
echo 'Creating configuration directory...'
mkdir $CONSUL_CONF_DIR
set_permissions $CONSUL_CONF_DIR $CONSUL_USER $CONSUL_USER '500'
  
# log file
echo 'Creating log file...'
touch $CONSUL_LOG
set_permissions $CONSUL_LOG $CONSUL_USER $CONSUL_USER '700'

