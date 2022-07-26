# name=ghost, instance_type=db.t2.micro, engine_version=8.0, storage=gp2, 
# allocated_space=20Gb, security_groups={mysql}, subnet_groups={ghost}

resource "aws_db_instance" "ghost" {
  db_name              = "ghostdb"
  password             = aws_ssm_parameter.db_password.value
  username             = "ghost"
  instance_class       = "db.t2.micro"
  engine               = "mysql"
  engine_version       = "8.0"
  allocated_storage    = 10
  vpc_security_group_ids = [ aws_security_group.mysql.id ]
  db_subnet_group_name =  aws_db_subnet_group.ghost.name
  skip_final_snapshot = true
}

