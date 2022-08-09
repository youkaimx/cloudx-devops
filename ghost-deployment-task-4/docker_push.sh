#!/bin/bash
echo "Will try to log into ECR (be sure docker is active)"
aws ecr get-login-password --region us-east-2 --profile youkaimx | docker login --username AWS --password-stdin 014834224223.dkr.ecr.us-east-2.amazonaws.com
docker pull ghost:4.12
docker tag ghost:4.12 014834224223.dkr.ecr.us-east-2.amazonaws.com/ghost:4.12
docker push 014834224223.dkr.ecr.us-east-2.amazonaws.com/ghost:4.12