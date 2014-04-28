#!/usr/bin/env bash

echo ">>> Installing MySQL Server $1"

mysql_package=mysql-server

if [ $1 == "5.6" ]; then
	mysql_package=mysql-server-5.6
fi

# Install MySQL without password prompt
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"

# Install MySQL Server
sudo apt-get install -y $mysql_package

# enable remote access
# setting the mysql bind-address to allow connections from everywhere
sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

MYSQL=`which mysql`

Q1="GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY 'root';"
Q2="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}"

$MYSQL -uroot -proot -e "$SQL"

service mysql restart
