
CREATE DATABASE IF NOT EXISTS `jackrabbit` DEFAULT CHARACTER SET latin1;

CREATE USER 'jcr_user'@'localhost' identified by '1Qaz@Wsx';
GRANT ALL PRIVILEGES ON jackrabbit.* TO 'jcr_user'@'localhost' WITH GRANT OPTION;

CREATE USER 'jcr_user'@'%' identified by '1Qaz@Wsx';
GRANT ALL PRIVILEGES ON jackrabbit.* TO 'jcr_user'@'%' WITH GRANT OPTION;

commit;