# Create Elastic File System
# Create EFS file system resource(name=ghost_content)
resource "aws_efs_file_system" "ghost_content" {
  creation_token = "ghost_content"
   
  tags = {
    Name = "ghost_content"
  }
}

# Create EFS mount targets for each AZ and assign them with {efs} security group
resource "aws_efs_mount_target" "public_a" {
  file_system_id = aws_efs_file_system.ghost_content.id
  subnet_id      = aws_subnet.public_a.id
}

resource "aws_efs_mount_target" "public_b" {
  file_system_id = aws_efs_file_system.ghost_content.id
  subnet_id      = aws_subnet.public_b.id
}
resource "aws_efs_mount_target" "public_c" {
  file_system_id = aws_efs_file_system.ghost_content.id
  subnet_id      = aws_subnet.public_c.id
}