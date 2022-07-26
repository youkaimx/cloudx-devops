# README

In this lab we will create the minimum required infrastructure for our Ghost application and will run it to work.   
To achieve this we will need to create some resources:

- Virtual Private Network with 3 subnets in different Avaliability Zones
- Security groups for necessary resources with minimal privileges
- SSH key pair for access to our instances
- LoadBalancer with 1 target group
- IAM role for access to EFS
- Elastic File System for shared content
- Launch Template with user-data script
- Auto Scaling Group
- Bastion host for SSH access to VPC

## Notes on the solution
- The description for each task is in each tf file as comments
- Currently, the user_data.sh mostly works, but the creation of the config file (at the end) does not. Also the sudo -u should be ghost_user (the created user) not sudo -u ghost... I resorted to change the file manually to make this work
- The location of the config file `config.development.json` should be in `/home/ghost_user/current/config.development.json`, not `/home/ghost_suer/config.development.json` as stated in the definition  


## Tips 
- To jump from the bastion host with public IP x.y.z.w to an auto scaling group host with internal IP 10.10.1.1 you can use something like `ssh -J ec2-user2@x.y.z.w ec2-user@10.10.1.1`
- To manually start the ghost server, another method is to go to `/home/ghost_user/current` and run `node index.js`