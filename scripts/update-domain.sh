#!/bin/bash

if [[ $# -eq 0 ]] ; then
  exit 1
fi

CUSTOM_DOMAIN=$1

echo "Updating PrestaShop domains ...";
req='UPDATE ps_configuration SET value = "'$CUSTOM_DOMAIN'" WHERE name IN ("PS_SHOP_DOMAIN", "PS_SHOP_DOMAIN_SSL"); UPDATE ps_shop_url SET domain = "'$CUSTOM_DOMAIN'", domain_ssl = "'$CUSTOM_DOMAIN'";'
mysql -h$DB_SERVER -P$DB_PORT -u$DB_USER -p$DB_PASSWD -D$DB_NAME -e "${req}" &
php /tmp/update-htaccess.php &
php /tmp/remove-cache.php &