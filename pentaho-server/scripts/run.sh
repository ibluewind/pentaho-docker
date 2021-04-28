#!/bin/sh

# wait for mysql ready
CHK_MYSQL=`echo "$(mysqladmin -u $MYSQL_USER -p$MYSQL_PASSWD -h $MYSQL_HOST ping | grep alive | wc -l)"`
while [ "$CHK_MYSQL" -eq "0" ]
do
    echo "waiting for pentaho-mysql..."
    sleep 3
    CHK_MYSQL=`echo "$(mysqladmin -u $MYSQL_USER -p$MYSQL_PASSWD -h $MYSQL_HOST ping | grep alive | wc -l)"`
done

echo "pentaho-mysql server is ready..."

./scripts/setup_mysql.sh

echo "Starting pentaho server..."
./start-pentaho.sh