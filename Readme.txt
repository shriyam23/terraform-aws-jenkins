Step1: 
Provision Jenkins Server with SonarQube installations on AWS with Terraform
* Prerequisites:
1. Install Terraform (version 1.2.5) : https://www.terraform.io/downloads
2. Install AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
3. Get AWS IAM access and secret key: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey
4. Configure AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
5. While configuring cli: set the region as us-east-1  

* Git clone: https://github.com/shriyam23/terraform-aws-jenkins.git
* Cd into the folder
* Create key-pair:
o ssh-keygen -t rsa -b 4096 -m pem -f my_key && mv my_key.pub modules/compute/my_key.pub && mv my_key my_key.pem && chmod 400 my_key.pem
* Edit secrets.tfvars: Put your ip address
* Intialize terraform: terraform init
* Run: terraform apply -var-file="secrets.tfvars"
* When prompted, enter yes
Step 2:
SSH into the server and do basic checks
* Get ip address of the server: terraform output -raw aws_public_ip
* Make a note of the server address
* SSH into the aws server: ssh -i my_key.pem  ubuntu@(terraform output -raw aws_public_ip)
* Do sudo systemctl status
o Enter q to exit it
o Keep checking the status until the State is showing as running and 0 jobs queued
* Check status of Jenkins service: sudo systemctl status jenkins
o It should show the status as active(running)
* Check status of Postgresql service: sudo systemctl status postgresql
o It should show the status as active(running)
Step 3:
Setting up sonarqube service
* Create the password for postgresql service: sudo passwd postgres
* PostgreSQL users peer authentication on unix sockets by default. Become postgres superuser: su - postgres
* Create a new user sonar: createuser sonar
* Enter psql: psql
* Type the following in the command line:
o ALTER USER sonar WITH ENCRYPTED password '<password_created_for_postgresql>';
o CREATE DATABASE sonarqube OWNER sonar;
o GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;
o \q
o exit
* Enable sonar service: sudo systemctl enable sonar
* Start sonar service: sudo systemctl start sonar
* Check status of sonar service: sudo systemctl status sonar
* Once the status is showing as running 
* In the browser go to the address: http://<server-ip-address>:9000
* A login screen will pop-up:
o Login and password both are admin
* Update your password screen will pop-up. Update the password to anything you want
* Once logged in, in the right upper corner of the screen, click on the Administrator button, click on ??My Account?? button
* A new screen will appear
* Click the Security Tab
* In the token section, enter the token name you want to create, click on the ??Generate Token?? button, and copy and save the generated token in your local
Step 3:
Setting up Jenkins service
* In the browser go to the address: http://<server-ip-address>:8080
* You will be greeted by the Unlock Jenkins screen:
* From the command line of the instance get the initialAdminspassword : sudo cat /var/lib/jenkins/secrets/initialAdminPassword
o Copy the password and paste into the ??Administrator Password?? block and press ??Continue??
* Choose ??Install the suggested plugins?? in the next screen
* Enter the requisite information in the next pages (or you can choose to skip those steps) till you don??t land on the dashboard page
* On the left side of the screen click on ??Manage Jenkins??
* In the system configuration section click on ??Manage Plugins?? 
* Go to the ??Available?? tab
* Search and tick the following plugins:
o Blue Ocean
o SonarQube Scanner
o HTTP Request
o Pipeline Maven Integration
* Choose ??Install without restart?? option
* Go back to the dashboard
* Go back to ??Manage Jenkins?? screen, and this time click on ??Configure System??
* Go to SonarQube installations sections
o Tick on the check for Environment Variables
o Enter the following information in the text boxes provided:
* Name: sonarqubelocal
* Server url: <sonarqube-server-address>
o In the Server authentical token, click on add and select Jenkins
o A Jenkins Credentials Provider screen will pop up:
* Select the domain as Global
* Kind as Secret Text
* Scope as Global
* Enter anything as the id
* In the Secret section paste the generated token from the Sonarqube server as described in the previous section
o Click on Add
o In the Authentical token section, your credentials with your given id will now appear in the dropdown menu
o Select that
* Click on Apply
Step 4:
Creating a pipeline
* Clone the project to your repository from https://github.com/shriyam23/petclinic.git
o It contains the requisite Jenkinsfile
* Edit the Jenkinsfile
o Update the -Dsonar.host.url value
o Update the -Dsonar.login with the token value created in Step 2
* Click to BlueOcean in the left side of Jenkins Dashboard
* Select Github
* Paste your Github access token in the text box (it also gives an option to create one, you can click on that option if you don??t have an access token already)
* Select the organization where the cloned repo is
* Choose the repository
* Choose ??Create Pipeline?? option
* The pipeline will be created an executed
* You should a screen with the pipeline build visualized 
* Go to Sonarqube dashboard and you would see a project named ??petclinic?? 




