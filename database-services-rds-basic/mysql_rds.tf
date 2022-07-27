# name=ghost, instance_type=db.t2.micro, engine_version=8.0, storage=gp2, 
# allocated_space=20Gb, security_groups={mysql}, subnet_groups={ghost}

resource "aws_db_instance" "mysql" {
  identifier           = "awsdb"
  db_name              = "immersionday"
  password             = "awspassword"
  username             = "awsuser"
  instance_class       = "db.t2.micro"
  engine               = "mysql"
  engine_version       = "5.7"
  allocated_storage    = 20
  parameter_group_name = "default.mysql5.7"
  vpc_security_group_ids = [ aws_security_group.db.id ]
#  db_subnet_group_name =  aws_db_subnet_group.ghost.name
  skip_final_snapshot = true
  auto_minor_version_upgrade = true
  backup_retention_period = 7
  copy_tags_to_snapshot = true
}

