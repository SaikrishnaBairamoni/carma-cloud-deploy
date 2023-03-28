#!/bin/bash

sudo apt update
sudo mkdir tmp && cd tmp
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.34/bin/apache-tomcat-9.0.34.tar.gz
tar -xzf apache-tomcat-9.0.34.tar.gz
mv apache-tomcat-9.0.34 tomcat
rm -rf tomcat/webapps/ROOT
rm -rf tomcat/webapps/docs
rm -rf tomcat/webapps/examples
rm -rf tomcat/webapps/host-manager
rm -rf tomcat/webapps/manager
rm -f apache-tomcat-9.0.34.tar.gz
git clone https://github.com/usdot-fhwa-stol/carma-cloud.git
