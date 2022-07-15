# README.md
- The description for each task is in each tf file as comments
- Currently, the user_data.sh mostly works, but the creation of the config file (at the end) does not. Also the sudo -u should be ghost_user (the created user) not sudo -u ghost... I resorted to change the file manually to make this work
- The location of the config file `config.development.json` should be in `/home/ghost_user/current/config.development.json`, not `/home/ghost_suer/config.development.json` as stated in the definition  
- To manually start the ghost server, go to `/home/ghost_user/current` and run `node index.js`
- To jump from the bastion host with public IP x.y.z.w to an auto scaling group host with internal IP 10.10.1.1 you can use something like `ssh -J ec2-user2@x.y.z.w ec2-user@10.10.1.1`
