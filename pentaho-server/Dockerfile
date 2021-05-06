FROM openjdk:8-jdk

ENV MAJOR_VERSION 9.1
ENV MINOR_VERSION 9.1.0.0-324
ENV PENTAHO_HOME /opt/pentaho
ENV PENTAHO_SERVER_HOME ${PENTAHO_HOME}/server/pentaho-server
ENV CATALINA_HOME ${PENTAHO_SERVER_HOME}/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV CATALINA_OPTS="-Djava.awt.headless=true -Xms4096m -Xmx6144m -XX:MaxPermSize=256m -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000"

#ENV MYSQL_HOST pentaho-mysql
#ENV MYSQL_USER root
#ENV MYSQL_PASSWD 1Qaz@Wsx
#ENV MYSQL_PORT 3306

# Make pentaho home directory
RUN mkdir -p ${PENTAHO_HOME}/server; mkdir ${PENTAHO_HOME}/.pentaho

# Setup pentaho User
RUN addgroup pentaho; adduser --home ${PENTAHO_HOME} --shell /bin/sh --gecos "" --ingroup pentaho --disabled-password pentaho

# Install wget, unzip, mysql client
RUN apt-get update && apt-get install -y default-mysql-client wget unzip vim net-tools

# Download pentaho-ce-server
#RUN wget -O  ${PENTAHO_HOME}/server/tmp.zip https://sourceforge.net/projects/pentaho/files/Pentaho%20${MAJOR_VERSION}/server/pentaho-server-ce-${MINOR_VERSION}.zip
COPY ./pentaho-server-ce-${MINOR_VERSION}.zip ${PENTAHO_HOME}/server/tmp.zip

RUN chown -R pentaho:pentaho ${PENTAHO_HOME}
USER pentaho
RUN unzip -q  ${PENTAHO_HOME}/server/tmp.zip -d ${PENTAHO_HOME}/server && rm -f  ${PENTAHO_HOME}/server/tmp.zip

# remove first time start prompt
WORKDIR ${PENTAHO_SERVER_HOME}
RUN rm -f promptuser.sh

######################################
# setup mysql repository
######################################
# quartz.properties
RUN sed -i -e 's/org.quartz.impl.jdbcjobstore.PostgreSQLDelegate/org.quartz.impl.jdbcjobstore.StdJDBCDelegate/' ${PENTAHO_SERVER_HOME}//pentaho-solutions/system/quartz/quartz.properties

# Hibernate setting
RUN sed -i -e 's/hsql.hibernate.cfg.xml/mysql5.hibernate.cfg.xml/' ${PENTAHO_SERVER_HOME}/pentaho-solutions/system/hibernate/hibernate-settings.xml

# replace audit log file
RUN cp ${PENTAHO_SERVER_HOME}/pentaho-solutions/system/dialects/mysql5/audit_sql.xml ${PENTAHO_SERVER_HOME}/pentaho-solutions/system

# set up jackrabbit repository
COPY config/repository.xml ${PENTAHO_SERVER_HOME}/pentaho-solutions/system/jackrabbit

# set up Tomcat META-INF/context.xml
COPY config/context.xml ${CATALINA_HOME}/webapps/pentaho/META-INF

# Pentaho Carte set up
COPY config/slave-server-config.xml ${PENTAHO_SERVER_HOME}/pentaho-solutions/system/kettle

# set up MySQL connection infomation
RUN rm -f ${CATALINA_HOME}/lib/mysql-connector-java-5.1.17.jar
#COPY ./mysql-connector-java-8.0.23.jar ${CATALINA_HOME}/lib
COPY ./mysql-connector-java-5.1.48.jar ${CATALINA_HOME}/lib
#RUN sed -i -e 's/jdbc:mysql:\/\/localhost/jdbc:mysql:\/\/${MYSQL_HOST}/' ${CATALINA_HOME}/webapps/pentaho/META-INF/context.xml

# copy MSSQL Server Driver
COPY ./mssql-jdbc-9.2.1.jre8.jar ${CATALINA_HOME}/lib

# change directory ownership to pentaho
USER root
COPY scripts ${PENTAHO_SERVER_HOME}/scripts
COPY config ${PENTAHO_SERVER_HOME}/config

RUN chown -R pentaho:pentaho ${PENTAHO_SERVER_HOME}/scripts
RUN chown -R pentaho:pentaho ${PENTAHO_SERVER_HOME}/config
RUN chown -R pentaho:pentaho ${CATALINA_HOME}/lib

RUN chmod -R +x ${PENTAHO_SERVER_HOME}/scripts

EXPOSE 8080

USER pentaho

# Run tomcat foreground
WORKDIR ${PENTAHO_SERVER_HOME}
RUN sed -i -e 's/\(exec ".*"\) start/\1 run/' ${CATALINA_HOME}/bin/startup.sh

ENTRYPOINT [ "./scripts/run.sh" ]