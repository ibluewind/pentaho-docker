CREATE DATABASE IF NOT EXISTS `hibernate` DEFAULT CHARACTER SET latin1;

USE hibernate;

CREATE USER 'hibuser'@'localhost' identified by '1Qaz@Wsx';
GRANT ALL PRIVILEGES ON hibernate.* TO 'hibuser'@'localhost' WITH GRANT OPTION;

CREATE USER 'hibuser'@'%' identified by '1Qaz@Wsx';
GRANT ALL PRIVILEGES ON hibernate.* TO 'hibuser'@'%' WITH GRANT OPTION;

commit;
