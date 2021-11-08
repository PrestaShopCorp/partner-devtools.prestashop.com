FROM prestashop/prestashop

COPY scripts/update-domain.sh /tmp/update-domain.sh
COPY scripts/update-htaccess.php /tmp/update-htaccess.php
COPY scripts/remove-cache.php /tmp/remove-cache.php
