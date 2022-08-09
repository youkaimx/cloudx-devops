# Create ECS related resources:
# ECS cluster
# name=ghost, containerInsights=enabled
resource "aws_ecs_cluster" "ghost" {
  name = "ghost"
  setting {
    name = "containerInsights"
    value = "enabled"
  }
}

# Task definition
# Name = task_def_ghost
# Requires compatibilities = FARGATE
# Task role = Task execution role = {arn of IAM role}
# Network mode = awsvpc
# Memory = 1024 (recommended)
# CPU = 256 (recommended)
# Volume name = ghost_volume, EFS volume configuration = {efs_id}

data "template_file" "task_definition" {
  template = file("./ghost_task_definition.tpl")
  vars     = {
    ECR_IMAGE = "${aws_ecr_repository.ghost.repository_url}:4.12"
    DB_URL    = "${aws_db_instance.ghost.address}"
    DB_USER   = "ghost"
    DB_NAME   = "ghostdb"
    DB_PASSWORD = "${aws_ssm_parameter.db_password.value}"
  }
}

output "task_definition" {
  value = data.template_file.task_definition.rendered
}

resource "aws_ecs_task_definition" "task_def_ghost" {
  container_definitions    = data.template_file.task_definition.rendered
  requires_compatibilities = ["FARGATE"]
  family                   = "ghost_container"
  execution_role_arn       = aws_iam_role.ghost_ecs_tasks_role.arn
  task_role_arn = aws_iam_role.ghost_ecs_tasks_role.arn
  # Be aware of network mode, if ignored, Terraform complains:
  # Error: failed creating ECS Task Definition (containers): ClientException: Fargate only supports network mode ‘awsvpc’.
  network_mode             = "awsvpc"
  # Be aware of CPU, if ignored, Terrform complains:
  # Error: failed creating ECS Task Definition (containers): ClientException: Fargate requires that 'cpu' be defined at the task level.
  cpu                      = 256
  # same with memory
  memory                   = 1024
  
  volume {
    name = "ghost_volume"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.ghost_content.id
      #root_directory = "/var/lib/ghost/content"
      root_directory = "/"
    }
  }
}



# Service
# Service name = ghost
# Launch type = FARGATE
# Task Definition = {task_def_ghost}
# Cluster = {ghost}
# Number of tasks = 1
# Application Load balancer: Use one create in Basic Infrastructure
# 
# Target group = {ghost-fargate}
# 
# 
# Assign public ip = false
# Subnets = list of private ECS subnets
# Security groups = {fargate_pool}

resource "aws_ecs_service" "ghost" {
  name = "ghost_service"
  cluster = aws_ecs_cluster.ghost.id
  task_definition = aws_ecs_task_definition.task_def_ghost.arn
  launch_type = "FARGATE"
  desired_count = 1
#  iam_role = aws_iam_role.ghost_ecs_tasks_role.arn
  
  # If network is awsvpc and the configuration is ommited, Terraform complains
  # Network Configuration must be provided when networkMode 'awsvpc' is specified.
   network_configuration {
     assign_public_ip = false
     subnets = [
      aws_subnet.private_a.id,
      aws_subnet.private_b.id,
      aws_subnet.private_c.id
     ]
     security_groups = [ aws_security_group.fargate_pool.id ]
   }

  load_balancer {
    target_group_arn = aws_lb_target_group.ghost_fargate.arn
    container_port = 2368
    # This must match with a task with definition with name ghost_container
    container_name = "ghost_container"
  }
}