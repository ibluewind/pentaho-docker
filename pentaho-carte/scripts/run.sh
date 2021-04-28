#!/bin/sh

# Working directory must be /opt/pentaho/data-integration
if [ ! "$PENTAHO_SERVER" ]; then
    PENTAHO_SERVER="pentaho-server"
fi

# replace PENTAHO_SERVER in repositories.xml to PENTAHO_SERVER environment variable's value
# ./.kettle/repositories.xml and ./repositories.xml
sed -i "s/PENTAHO_SERVER/$PENTAHO_SERVER/" ${PENTAHO_HOME}/.kettle/repositories.xml
sed -i "s/PENTAHO_SERVER/$PENTAHO_SERVER/" repositories.xml

# replace hostname in carte-master-config.xml and carte-slave-config.xml
HOSTNAME=`hostname -f`

# replace carte port
if [ ! "$CARTE_MASTER_PORT" ]; then
    CARTE_MASTER_PORT=9000
fi

if [ ! "$CARTE_SLAVE_PORT" ]; then
    CARTE_SLAVE_PORT=9001
fi

sed -i "s/CARTE_MASTER_PORT/$CARTE_MASTER_PORT/" carte-master-config.xml
sed -i "s/CARTE_MASTER_PORT/$CARTE_MASTER_PORT/" carte-slave-config.xml
sed -i "s/CARTE_SLAVE_PORT/$CARTE_SLAVE_PORT/" carte-slave-config.xml

case $CARTE_MASTER in
"Y")
    echo "CARTE Set to Master"
    sed -i "s/HOSTNAME/$HOSTNAME/" carte-master-config.xml
    cp carte-master-config.xml carte-config.xml
    ;;
"N")
    echo "CARTE Set to Slave"

    # replace CARTE_MASTER_HOSTNAME to $CARTE_MASTER_HOSTNAME
    if [ ! "$CARTE_MASTER_HOSTNAME" ]; then
        CARTE_MASTER_HOSTNAME="carte_master";
    fi

    if [ ! "$CARTE_SLAVE_NAME" ]; then
        CARTE_SLAVE_NAME=carte-slave
    fi

    # set master information
    sed -i "s/CARTE_MASTER_HOSTNAME/$CARTE_MASTER_HOSTNAME/" carte-slave-config.xml
    sed -i "s/HOSTNAME/$HOSTNAME/" carte-slave-config.xml
    sed -i "s/CARTE_SLAVE_NAME/$CARTE_SLAVE_NAME/" carte-slave-config.xml
    
    cp carte-slave-config.xml carte-config.xml
    ;;
*)
    echo "CARTE Set to Master"
    cp carte-master-config.xml carte-config.xml
    ;;
esac

carte.sh carte-config.xml