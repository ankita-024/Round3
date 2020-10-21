#_____________________________Environment standard Config____________________________
aws_management_account = "222222222222"
aws_client_account = "111111111111"
availability_zone = "us-east-1a"
vpc_name = "clientvpc"
vpc_id = "vpc-ofeigfewifhewiuuhqf"
account_type = "nonprod"
subnet = "subnet-1"
db_eni = "db_eni"
db_ebs = "db_ebs"
db_sg = "db_sg"
#___________________________Tags_______________________________
environment_tag = "dev"
team_tag = "team_one"
#____________________KMS_______________________
kms_deployer_arn = "arn:aws:iam::        "
#____________________AMIS_____________________
web_ami = "web"
app_ami = "app"
db_ami = "db"
#________________Userdata____________________
sql_url = "https://pre-dev/service/local/repo/IND/SQL/SQL-developer.iso "
web_zip = "https://web/artifactory/web.zip"
app_location = "https://app/artifactory/app.ear"
#_______________S3_________________________________________
project_folder_bucket ="MY_APP"
db_bucket = "my-app-db"
logs_bucket = "my-app-logs"
bucket acl = "private"
#__________________DB____________________________
hostname = "EXUFHGEIFO1"
#_______________VAULT_____________
vault_addr = "https://my-vault.com"
vault_web_role = "my-app-web"
vault_app_role = "my-app-app"
#________________OU path__________________
db_ou_path = "OU=ugyd,OU=jfwieh,DC=iiefi"
web_ou_path = "OU=hvew,OU=huvuewbf,DC=lkif"
app_ou_path = "OU=fuew,OU=bbfwu,DC=hufewi"
#______________SG Configurations_____________
#________Ports______

port_8080 = "8080"
port_3912 = "3912"
port_4401 = "4401"
port_1455 = "1455"
port_1180 = "1180"
port_3175 = "3175"
port_5985 = "5985"
port_1415 = "1415" 
port_3175 ="3175"
port_3126 ="3126"
#_____________SGS___
#_______SG IDs___
sg_vault = "sg-78460y"
sg_db_jenkins="sg-hihf6e"
sg_artifactory="sg-87yq28"
#____CIDR__________
cidr_des="10.0.0.1/16,---"
cidr_app="10.1.0.0/16,---"
cidr_app_dr=""
cidr_med=""
cidr_ext=""
cidr_dev=""
cidr_db_serv=""
cidr_db_serv_dr=""
#_________Shared SG config_______
#_____shared web to app alb security grp
web_to_App_alb_shared_sg ="dev-shared-web-to-app-alb-sg"
shared_sg_tag_role="shared-web-to-app-alb-sg"
#_______shared web to db sg_______
web_to_db_sg_name ="dev-shared-web-to-db-sg"
shared_sg_db_tag_role= "shared-web-to-db-sg"
#_______shared web alb to web asg sg_____
shared_web_to_alb






