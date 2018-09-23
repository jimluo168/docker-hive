FROM registry.advanpro.cn/hadoop-base:2.0.0-hadoop2.7.7-java8
MAINTAINER luojimeng <luojimeng@advanpro.hk>

ENV HIVE_VERSION 2.3.3

ENV HIVE_HOME /opt/hive
ENV PATH $HIVE_HOME/bin:$PATH
ENV HADOOP_HOME /opt/hadoop-${HADOOP_VERSION}


WORKDIR /opt

#Install Hive and PostgreSQL JDBC
# wget https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
# RUN apt-get update && apt-get install -y wget procps && \
# 	wget http://mirrors.shu.edu.cn/apache/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
# 	tar -xzvf apache-hive-$HIVE_VERSION-bin.tar.gz && \
# 	mv apache-hive-$HIVE_VERSION-bin hive && \
# 	wget https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar -O $HIVE_HOME/lib/postgresql-jdbc.jar && \
# 	rm apache-hive-$HIVE_VERSION-bin.tar.gz
# apt-get --purge remove -y wget && \
# apt-get clean && \
# rm -rf /var/lib/apt/lists/*

COPY apache-hive-${HIVE_VERSION}-bin.tar.gz /opt/apache-hive-${HIVE_VERSION}-bin.tar.gz

# RUN apt-get update && apt-get install -y wget procps && \
# 	  tar -xzvf apache-hive-${HIVE_VERSION}-bin.tar.gz && \
# 	  mv apache-hive-${HIVE_VERSION}-bin hive && \
# 	  wget https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar -O $HIVE_HOME/lib/postgresql-jdbc.jar && \
# 	  rm apache-hive-${HIVE_VERSION}-bin.tar.gz

RUN apt-get update && apt-get install -y wget procps && \
		tar -xzvf apache-hive-${HIVE_VERSION}-bin.tar.gz && \
		mv apache-hive-${HIVE_VERSION}-bin hive && \
		rm apache-hive-${HIVE_VERSION}-bin.tar.gz

COPY  mysql-connector-java-5.1.47.jar $HIVE_HOME/lib/mysql-connector-java-5.1.47.jar

#Spark should be compiled with Hive to be able to use it
#hive-site.xml should be copied to $SPARK_HOME/conf folder

#Custom configuration goes here
ADD conf/hive-site.xml $HIVE_HOME/conf
ADD conf/beeline-log4j2.properties $HIVE_HOME/conf
ADD conf/hive-env.sh $HIVE_HOME/conf
ADD conf/hive-exec-log4j2.properties $HIVE_HOME/conf
ADD conf/hive-log4j2.properties $HIVE_HOME/conf
ADD conf/ivysettings.xml $HIVE_HOME/conf
ADD conf/llap-daemon-log4j2.properties $HIVE_HOME/conf

COPY startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 10000
EXPOSE 10002

ENTRYPOINT ["entrypoint.sh"]
CMD startup.sh
