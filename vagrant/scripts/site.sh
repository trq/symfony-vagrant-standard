#!/usr/bin/env bash

[[ -z $1 ]] && { echo "!!! hostname not set. Check the Vagrant file."; exit 1; }
[[ -z $2 ]] && { echo "!!! db_name not set. Check the Vagrant file."; exit 1; }

HOSTNAME="$1"
DBNAME="$2"

echo ">>> Installing $HOSTNAME Website"

SSL_DIR="/etc/ssl/$HOSTNAME"

SUBJ="
C=AU
ST=Nsw
O=$HOSTNAME
localityName=Sydney
commonName=$HOSTNAME
organizationalUnitName=
emailAddress=
"
sudo mkdir -p "$SSL_DIR"

sudo openssl genrsa -out "$SSL_DIR/$HOSTNAME.key" 1024
sudo openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key "$SSL_DIR/$HOSTNAME.key" -out "$SSL_DIR/$HOSTNAME.csr" -passin pass:thisisfooandfooisgood
sudo openssl x509 -req -days 365 -in "$SSL_DIR/$HOSTNAME.csr" -signkey "$SSL_DIR/$HOSTNAME.key" -out "$SSL_DIR/$HOSTNAME.crt"

sed "s/{HOSTNAME}/${HOSTNAME}/g" /vagrant/vagrant/files/vhost.conf | sudo tee /etc/apache2/sites-enabled/"${HOSTNAME}".conf
sudo rm /etc/apache2/sites-enabled/000-*

mysql -uroot -proot -e "CREATE DATABASE $DBNAME;"

# Patch the AppKernel for better performance with Vagrant
# cd /vagrant/app
# patch < /vagrant/vagrant/files/app_kernel.patch

sudo mkdir -p /dev/shm/symfony/cache
sudo mkdir -p /dev/shm/symfony/logs
sudo chown -R vagrant:www-data /dev/shm/symfony

chmod g+ws /dev/shm/symfony/cache
chmod g+ws /dev/shm/symfony/logs

sudo service apache2 restart
sudo service php5-fpm restart

cd /vagrant
composer install --dev

echo "Done"
echo "Execute the following to add $HOSTNAME to your hosts file:"
echo "echo $3 $HOSTNAME | sudo tee -a /etc/hosts"
echo "Then visit http://$HOSTNAME in your browser"
echo
echo "You may also want to apply the following patch to the AppKernel which should improve performance when using an NSF filesystem"
echo "cd app && patch < ../vagrant/files/app_kernel.patch"
