resource "aws_efs_file_system" "efs" {
  throughput_mode = "bursting"
  
}

resource "aws_efs_mount_target" "mount" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id = aws_instance.ec2.subnet_id
  security_groups = [ aws_security_group.EFS-sg.id ]
}