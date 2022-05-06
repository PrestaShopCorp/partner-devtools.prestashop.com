FROM prestashop/prestashop

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY scripts/update-domain.sh /tmp/update-domain.sh
COPY scripts/update-htaccess.php /tmp/update-htaccess.php
COPY scripts/remove-cache.php /tmp/remove-cache.php

COPY prestashop* /var/www/html/

RUN chmod +x /tmp/update-domain.sh \
  && grep -qxF 'ServerName 127.0.0.1' /etc/apache2/apache2.conf || echo 'ServerName 127.0.0.1' >> /etc/apache2/apache2.conf