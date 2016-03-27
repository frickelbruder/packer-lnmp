#!/bin/bash

ECHOWRAPPER="==============================================\n\n%s\n\n==============================================\n"

#MySQL-Database - percona flavor
printf $ECHOWRAPPER "Installing Percona Mysql"
wget https://repo.percona.com/apt/percona-release_0.1-3.$(lsb_release -sc)_all.deb
dpkg -i percona-release_0.1-3.$(lsb_release -sc)_all.deb
apt-get update
apt-get install -y percona-server-server

#Nginx - But a current version please
printf $ECHOWRAPPER "Installing NGINX"
cat <<EOT >> /etc/apt/sources.list.d/nginx.list
deb http://nginx.org/packages/mainline/ubuntu trusty nginx
deb-src http://nginx.org/packages/mainline/ubuntu trusty nginx
EOT

wget http://nginx.org/packages/keys/nginx_signing.key
cat nginx_signing.key | sudo apt-key add -
rm nginx_signing.key

apt-get update
apt-get install -y nginx

#PHP
printf $ECHOWRAPPER "Installing PHP"
apt-get install -y php5-fpm php5-cli php5-mysql php5-imagick php5-gd php5-xdebug php-pear php5-dev


##PHPDEVELOPMENT
###PHPUNIT
printf $ECHOWRAPPER "Installing Phpunit"
wget https://phar.phpunit.de/phpunit-old.phar
mv phpunit-old.phar /usr/local/bin/phpunit.phar
chmod a+x /usr/local/bin/phpunit.phar
ln -s /usr/local/bin/phpunit.phar /usr/local/bin/phpunit

###COMPOSER
printf $ECHOWRAPPER "Installing Composer"
php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
php -r "if (hash('SHA384', file_get_contents('composer-setup.php')) === '41e71d86b40f28e771d4bb662b997f79625196afcca95a5abf44391188c695c6c1456e16154c75a211d238cc3bc5cb47') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer.phar
ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

###PHPAB
printf $ECHOWRAPPER "Installing phpab"
wget https://github.com/theseer/Autoload/releases/download/1.21.0/phpab-1.21.0.phar
mv phpab-1.21.0.phar /usr/local/bin/phpab.phar
chmod a+x /usr/local/bin/phpab.phar
ln -s /usr/local/bin/phpab.phar /usr/local/bin/phpab

#phpmyadmin
printf $ECHOWRAPPER "Installing PHPMyAdmin"
printf $ECHOWRAPPER "Setting PHPMyAdmin debconf settings"
debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean false '
debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-reinstall boolean false '
debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect '
debconf-set-selections <<< 'phpmyadmin phpmyadmin/internal/skip-preseed boolean true '
printf $ECHOWRAPPER "Doing the install"
apt-get install -y phpmyadmin

#Ruby (required for compass)
printf $ECHOWRAPPER "Installing Ruby"
apt-get -y install ruby

#Compass
printf $ECHOWRAPPER "Installing Compass"
gem install compass

#NodeJS/NPM
printf $ECHOWRAPPER "Installing Node/NPM"
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
apt-get install -y nodejs

#Bower
printf $ECHOWRAPPER "Installing Bower"
npm install -g bower