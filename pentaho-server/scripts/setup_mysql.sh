#!/bin/sh
# docker run 이나 docker-compose 실행 시에 MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD ENV가 설정되어야 한다.
# 만일 MYSQL 관련 환경변수가 없으면 임의로 지정한다.

if [ ! "$MYSQL_HOST" ]; then
    MYSQL_HOST="pentaho-mysql"
    MYSQL_USER="root"
    MYSQL_PASSWD="1Qaz@Wsx"
fi

# Database 생성 체크
echo "Checking Mysql Databases..."
CHK_QUARTZ=`echo "$(mysql -u $MYSQL_USER -p$MYSQL_PASSWD -h $MYSQL_HOST -e "show databases" | grep quartz | wc -l)"`
CHK_HIBERNATE=`echo "$(mysql -u $MYSQL_USER -p$MYSQL_PASSWD -h $MYSQL_HOST -e "show databases" | grep hibernate | wc -l)"`
CHK_JCR=`echo "$(mysql -u $MYSQL_USER -p$MYSQL_PASSWD -h $MYSQL_HOST -e "show databases" | grep jackrabbit | wc -l)"`

echo "quarz:  $CHK_QUARTZ"
echo "hibernate: $CHK_HIBERNATE"
echo "jcr: $CHK_JCR"

# MySQL 스크립트 실행
if [ "$CHK_QUARTZ" -eq "0" ]; then
    echo "Creating quartz database..."
    mysql -u $MYSQL_USER -p$MYSQL_PASSWD -h $MYSQL_HOST < $PENTAHO_SERVER_HOME/pentaho-server/config/data/mysql/create_quartz_mysql.sql
else
    echo "quartz already exists..."
fi
if [ "$CHK_JCR" -eq "0" ]; then
    echo "Creating jackrabbit database..."
    mysql -u $MYSQL_USER -p$MYSQL_PASSWD -h $MYSQL_HOST < $PENTAHO_SERVER_HOME/pentaho-server/config/data/mysql/create_jcr_mysql.sql
else
    echo "jackrabbit already exists..."
fi
if [ "$CHK_HIBERNATE" -eq "0" ]; then
    echo "Creating repository database..."
    mysql -u $MYSQL_USER -p$MYSQL_PASSWD -h $MYSQL_HOST < $PENTAHO_SERVER_HOME/pentaho-server/config/data/mysql/create_repository_mysql.sql
else
    echo "repository already exists..."
fi

if [ ! -f ".mysql_config" ]; then
    HOSTNAME=`hostname -f`
    sed -i "s/node1/${HOSTNAME}/g" ${PENTHAO_SERVER_HOME}/pentaho-server/pentaho-solutions/system/jackrabbit/repository.xml
    touch .mysql_config
fi