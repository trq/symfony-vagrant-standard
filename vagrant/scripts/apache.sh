#!/usr/bin/env bash

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

echo ">>> Installing Apache Server"

# Install Apache
sudo apt-get install -y apache2-mpm-event libapache2-mod-fastcgi

echo ">>> Configuring Apache"

echo "ServerName wc.lcl" | sudo tee -e /etc/apache2/apache2.conf

# Apache Config
sudo a2enmod rewrite actions ssl

if [[ $PHP_IS_INSTALLED -eq 0 ]]; then
    # PHP Config for Apache
    cat > /etc/apache2/conf-available/php5-fpm.conf << EOF
    <IfModule mod_fastcgi.c>
            AddHandler php5-fcgi .php
            Action php5-fcgi /php5-fcgi
            Alias /php5-fcgi /usr/lib/cgi-bin/php5-fcgi
            FastCgiExternalServer /usr/lib/cgi-bin/php5-fcgi -socket /var/run/php5-fpm.sock -pass-header Authorization
            <Directory /usr/lib/cgi-bin>
                    Options ExecCGI FollowSymLinks
                    SetHandler fastcgi-script
                    Require all granted
            </Directory>
    </IfModule>
EOF
    sudo a2enconf php5-fpm
fi

sudo service apache2 restart
