FROM openjdk:8-jdk

ENV MAJOR_VERSION 9.1
ENV MINOR_VERSION 9.1.0.0-324
ENV PENTAHO_HOME /opt/pentaho
ENV KETTLE_HOME ${PENTAHO_HOME}/data-integration
ENV PENTAHO_JAVA_HOME ${JAVA_HOME}
ENV PATH $KETTLE_HOME:$PATH

# make pentaho home directory
RUN mkdir -p ${PENTAHO_HOME}; mkdir -p ${PENTAHO_HOME}/.kettle
WORKDIR ${PENTAHO_HOME}

# Setup pentaho user
RUN addgroup pentaho; adduser --home ${PENTAHO_HOME} --shell /bin/sh --gecos "" --ingroup pentaho --disabled-password pentaho

# Install wget, unzip, vim
RUN apt-get update && apt-get install -y wget unzip vim net-tools

RUN chown -R pentaho:pentaho ${PENTAHO_HOME}
USER pentaho

# Download pdi-ce
RUN wget -qO /tmp/pdi-ce.zip https://sourceforge.net/projects/pentaho/files/Pentaho%20${MAJOR_VERSION}/client-tools/pdi-ce-${MINOR_VERSION}.zip
# COPY ./pdi-ce-${MINOR_VERSION}.zip ${PENTAHO_HOME}
RUN unzip -q /tmp/pdi-ce.zip -d ${PENTAHO_HOME} && rm -f /tmp/pdi-ce.zip

# Copy Respoistory Configuration file
USER root
COPY ./config/repositories.xml ${PENTAHO_HOME}/.kettle
COPY ./config/repositories.xml ${PENTAHO_HOME}/data-integration
COPY ./config/carte-master-config.xml ${KETTLE_HOME}
COPY ./config/carte-slave-config.xml ${KETTLE_HOME}
RUN chown pentaho:pentaho ${PENTAHO_HOME}/.kettle/repositories.xml ${KETTLE_HOME}/repositories.xml ${KETTLE_HOME}/carte-master-config.xml ${KETTLE_HOME}/carte-slave-config.xml

# Copy Entry point shell script
COPY ./scripts ${KETTLE_HOME}/scripts
RUN chown -R pentaho:pentaho ${KETTLE_HOME}/scripts
RUN chmod +x ${KETTLE_HOME}/scripts/run.sh

# Copy Database JDBC Driver
COPY mysql-connector-java-8.0.23.jar ${KETTLE_HOME}/lib
COPY mssql-jdbc-9.2.1.jre8.jar ${KETTLE_HOME}/lib
RUN chown pentaho:pentaho ${KETTLE_HOME}/lib/mysql-connector-java-8.0.23.jar ${KETTLE_HOME}/lib/mssql-jdbc-9.2.1.jre8.jar

#VOLUME ["/opt/pentaho/repository"]
EXPOSE 11000

WORKDIR $KETTLE_HOME
USER pentaho
#ENTRYPOINT ["carte.sh", "127.0.0.1", "8081", "-u", "carte-admin", "-p", "carte-admin"]
#CMD ["carte.sh", "carte-master-config.xml"]
CMD ["/bin/sh", "-c", "./scripts/run.sh"]
