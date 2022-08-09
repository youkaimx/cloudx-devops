[
    {
    "name": "ghost_container",
    "image": "${ECR_IMAGE}",
    "cpu": 256,
    "memory": 1024, 
    "essential": true,
    "environment": [
        { "name" : "database__client", "value" : "mysql"},
        { "name" : "database__connection__host", "value" : "${DB_URL}"},
        { "name" : "database__connection__user", "value" : "${DB_USER}"},
        { "name" : "database__connection__password", "value" : "${DB_PASSWORD}"},
        { "name" : "database__connection__database", "value" : "${DB_NAME}"}
    ],
    "mountPoints": [
        {
            "containerPath": "/var/lib/ghost/content",
            "sourceVolume": "ghost_volume"
        }
    ],
    "portMappings": [
        {
        "containerPort": 2368,
        "hostPort": 2368
        }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "ghost_log_group",
            "awslogs-region": "us-east-2",
            "awslogs-stream-prefix": "fargate-ghost"
        }
    }
    }
] 
