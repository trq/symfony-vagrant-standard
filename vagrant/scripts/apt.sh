#!/usr/bin/env bash

[[ -z $1 ]] && { echo "!!! No php_version set. Check the vagrant file."; exit 1; }
[[ -z $2 ]] && { echo "!!! No mysql_version set. Check the Vagrant file."; exit 1; }

sudo apt-get install -y build-essential python-software-properties

# PHP
if [ "$1" == "latest" ]; then
    sudo add-apt-repository -y ppa:ondrej/php5
fi

if [ "$1" == "previous" ]; then
    sudo add-apt-repository -y ppa:ondrej/php5-oldstable
fi


# Mysql
if [ "$2" == "5.6" ]; then
	sudo add-apt-repository -y ppa:ondrej/mysql-5.6
fi

# Apache
sudo add-apt-repository -y ppa:ondrej/apache2

sudo apt-get update
