#!/bin/sh

notify()
{
    echo "\033[0;32m$1\033[0m"
}

wait()
{
	echo "\033[0;31m$1\033[0m"
	read -p "When finished hit enter to continue..."
}

notify "Showing hidden files in Finder"
defaults write com.apple.finder AppleShowAllFiles TRUE
killall Finder
wait "Verify Finder restarted and you can see hidden files"

notify "Starting Apache"
sudo apachectl start
wait "Verify it started or is running"

notify "Opening Browser"
python -mwebbrowser http://localhost
wait "Verify that the page says It works!"

notify "Checking PHP Version"
php -v
wait "Make sure your command line responds with details on PHP"

Checking to make sure Apache Can Connect To PHP
notify "Loading PHP Module To Apache"
sudo sed -i '' 's/#LoadModule php5_module/LoadModule php5_module/g' /etc/apache2/httpd.conf

notify "Creating phpinfo(); page"
echo "<?php phpinfo(); ?>" > /Library/WebServer/Documents/info.php
python -mwebbrowser http://localhost/info.php
wait "Check to make sure the info.php page works"

notify "Configuring Apache mod_rewrite"
sudo sed -i '' 's/#LoadModule rewrite_module/LoadModule rewrite_module/g' /etc/apache2/httpd.conf
sudo sed -i '' 's/AllowOverride None/AllowOverride All/g' /etc/apache2/httpd.conf

notify "Restarting Apache"
sudo apachectl restart

notify "Configuration Complete!"