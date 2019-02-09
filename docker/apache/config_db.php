<?php
class DB extends DBmysql {
   public $dbhost     = getenv("MARIADB_PORT_3306_TCP_ADDR");
   public $dbuser     = getenv("MARIADB_ENV_MYSQL_USER");
   public $dbpassword = getenv("MARIADB_ENV_MYSQL_PASSWORD");
   public $dbdefault  = getenv("MARIADB_ENV_MYSQL_DATABASE");
}
