#!/usr/bin/bash
#
# gmzabos        28.07.2017
#
# Install + Configure Apache webserver
#
# Prerequisites:    - CentOS 7 server
#                   - yum install git
#                   - git clone https://github.com/gmzabos/sak.git /root/scripts

#########################################
# Set Variables
#########################################
SAK="/root/scripts/sak/"
WEB="/etc/httpd/conf.d/"

#########################################
# Install epel-release
#########################################
yum -y install epel-release

#########################################
# Install useful tools
#########################################
yum -y install wget git bind-utils net-tools telnet libselinux-python unzip tree mailx strace lsof ntp


#########################################
# Install Sigal (http://sigal.saimon.org)
#########################################
yum -y install python34 python34-pip
pip3 install --upgrade pip
pip3 install sigal

#########################################
# Install Apache httpd
#########################################
yum -y install httpd
cp ${SAK}/centos-webserver/www.conf ${WEB}
service httpd start
chkconfig httpd on




#########################################
# Send notification
#########################################