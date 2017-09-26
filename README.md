#setting base image as CentOs6
FROM centos:centos6

#Giving a maintainer name
MAINTAINER DevOps@zycus

#Installing necessary packages for python, Apache and MongoDB(Appending to a single RUN command to reduce the number of layers for an optimized image)
RUN yum -y update && \
        yum install -y tar && \
        yum install -y wget && \
        yum -y install sudo && \
        yum -y install epel-release && \
        yum -y install mongodb-server && \
        mkdir -p /data/db && mkdir -p /scripts && \
#Installing python2.7
        yum groupinstall "Development tools" -y && \
        sudo yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel && \
        cd /opt;sudo wget --no-check-certificate https://www.python.org/ftp/python/2.7.8/Python-2.7.8.tar.xz && \
        cd /opt;sudo tar xf Python-2.7.8.tar.xz && \
        cd /opt/Python-2.7.8;./configure --prefix=/usr/local && \
        cd /opt/Python-2.7.8;sudo make && sudo make altinstall && \
#Installing Open JDK 7
        yum install -y java-1.7.0-openjdk java-1.7.0-openjdk-devel && \
        yum clean all && \
# Setting up the apache tomcat server
        cd /tmp;wget http://www-eu.apache.org/dist/tomcat/tomcat-7/v7.0.79/bin/apache-tomcat-7.0.79.tar.gz && \
        cd /tmp;gunzip apache-tomcat-7.0.79.tar.gz && tar xvf apache-tomcat-7.0.79.tar && \
        cd /tmp;mv apache-tomcat-7.0.79 /opt/tomcat7 && chmod -R 755 /opt/tomcat7

#setting Javahome and Catalina home environment variables
ENV JAVA_HOME /usr
ENV CATALINA_HOME /opt/tomcat7

#Opening a default port for MongoDB and Apache Tomcat
EXPOSE 27017
EXPOSE 8080

#Copying scripts into docker image to start all the processes/services to be started at the start of container
COPY ./starts.sh /scripts

#start all the processes/services to be started at the start of container
ENTRYPOINT ["/scripts/starts.sh"]
