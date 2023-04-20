#!/bin/bash
sudo apt update
sudo apt install openjdk-11-jdk-headless
sudo source .bashrc 
sudo mkdir tmp && cd tmp
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.34/bin/apache-tomcat-9.0.34.tar.gz
tar -xzf apache-tomcat-9.0.34.tar.gz
mv apache-tomcat-9.0.34 tomcat
