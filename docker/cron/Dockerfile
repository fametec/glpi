FROM fametec/glpi-php-fpm

RUN { \
	echo '#!/bin/bash' ; \
	echo ; \
	echo 'while true' ; \
	echo 'do ' ; \
	echo '  cd /usr/share/nginx/html/glpi/ ' ; \
	echo '  /usr/local/bin/php front/cron.php' ; \
	echo '  tail files/_log/cron.log' ; \
	echo '  sleep 60' ; \
	echo 'done' ; \
	echo ; \
    } > /entrypoint.sh \
  && chmod +x /entrypoint.sh


ENTRYPOINT ["/entrypoint.sh"]

