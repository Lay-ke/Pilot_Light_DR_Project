Making use of terraform workspaces
With workspaces I'm able to use the same modules to provision infrastructure in different environment

to set the workspace you could do so by exporting the variable:
export TF_WORKSPACE=dev
OR 
terraform workspace select dev
NOTE: setting the TF_WORKSPACE variable takes precedence over selecting it via the command line

terraform apply -var-file=$(terraform workspace show).tfvars

My dr infrastructure depended on outputs from the active region such as rds instance arn to provision the read replica. I had to use data sources to reference the state file of the active region to be able to get such output.

the reason i wasn't able to create the rds replica had to do with the kms policy. The kms policy didn't give the user and the rds service permissions to use or perform operations with the key. I also had to define a policy for the replica key too to allow access within its region