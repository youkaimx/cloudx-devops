# Note: 
# On the secret portion of the practice (https://catalog.workshops.aws/general-immersionday/en-US/basic-modules/50-rds/rds/3-rds) 
#you should also include a key dbname and a key host so your PHP app finds the database. 
# Otherwise you'll see errors like this in /var/log/php-fpm/www-error.log
# [root@ip-172-31-38-91 php-fpm]# pwd
# /var/log/php-fpm
# [root@ip-172-31-38-91 php-fpm]# tail -3 www-error.log
# [27-Jul-2022 10:26:46 UTC] PHP Notice:  Undefined index: host in /var/www/html/rds.conf.php on line 71
# [27-Jul-2022 10:26:46 UTC] PHP Notice:  Undefined index: dbname in /var/www/html/rds.conf.php on line 72
# [27-Jul-2022 10:26:46 UTC] PHP Warning:  mysqli_connect(): (HY000/2002): No such file or directory in /var/www/html/rds-read-data.php on line 15

resource "aws_secretsmanager_secret" "mysecret" {
  name        = "mysecret"
  description = "The password for the database"
}

resource "aws_secretsmanager_secret_version" "dbpassword" {
  secret_id = aws_secretsmanager_secret.mysecret.id
  secret_string = jsonencode(var.dbpassword)
}

# The variable values are provided via a .auto.tfvars file that should be listed
# in the gitignore file
variable "dbpassword" {
  description = "The password for the database"
}