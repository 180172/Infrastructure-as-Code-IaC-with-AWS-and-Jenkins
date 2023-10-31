# Infrastructure as Code (IaC) with AWS and Jenkins

### This project showcases the implementation of Infrastructure as Code (IaC) using Terraform, AWS, and Jenkins to automate the provisioning of remote Ansible nodes and a control node. The infrastructure is designed for Ansible automation, facilitating system configuration and management. 

### Below are the key components and features of this project:

## Prerequisite 

- AWS account

- GitHub account
 
If you don't have Terraform software visit below Terraform official website below.

```
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
```

## STEP 1:

#### Create EC2 instance:
- Click on Create EC2 instance

![Screenshot 2023-10-29 172634](https://github.com/180172/Terraform-project-2/assets/110009356/20a439af-58ec-441c-9ea4-9c2408709f1d)


- Select Amazon Linux 2 Image

![Screenshot 2023-10-29 172953](https://github.com/180172/Terraform-project-2/assets/110009356/17bec88c-bd4a-479c-ac45-414cb72bb9da)

- Instance type should be "t2.micro" and select key-pair

![Screenshot 2023-10-29 173028](https://github.com/180172/Terraform-project-2/assets/110009356/2f3db32a-99ee-46c1-9e98-4b465a8bff5e)

- Select VPC and subnets

![Screenshot 2023-10-29 173252](https://github.com/180172/Terraform-project-2/assets/110009356/68deda57-3d2b-411a-9bff-80265e434e60)

- Create a new security group. Allow SSH and All traffic Anywhere 

![Screenshot 2023-10-29 173600](https://github.com/180172/Terraform-project-2/assets/110009356/f04f44ea-f4ef-4563-8a2d-eca91a35718a)

- Add storage of 15GB for storage

![Screenshot 2023-10-29 173758](https://github.com/180172/Terraform-project-2/assets/110009356/cd39420c-f366-41f6-a508-1dfc9565352e)

- Click on Create instance

## STEP 2:
### Create IAM role

- Open IAM console

![Screenshot 2023-10-29 174037](https://github.com/180172/Terraform-project-2/assets/110009356/6fe95117-54f7-438f-bdee-cda13b2cabd9)

- Select "AWS service"

![Screenshot 2023-10-29 174351](https://github.com/180172/Terraform-project-2/assets/110009356/16e87290-1258-4925-a4ab-009b4a5f1dfe)

![Screenshot 2023-10-29 174458](https://github.com/180172/Terraform-project-2/assets/110009356/5de0389a-3f29-400f-84b4-74cec29c3697)

- Click on next

- Under "Add permissions" select EC2Full Access, S3Full Access, and DynamoDBFull Access

- Add name and click on Create role

## STEP 3:

### Attach IAM policy to EC2 Instance

- Select the Instance that you created

- Under Actions => Security => Modify IAM role.

![Screenshot 2023-10-29 175309](https://github.com/180172/Terraform-project-2/assets/110009356/7cc07342-8eac-408e-83a2-d9c24460eb9a)

- Select IAM role that you created and click on Update IAM role

![Screenshot 2023-10-29 175511](https://github.com/180172/Terraform-project-2/assets/110009356/312db4cc-76b4-409b-9af5-e1f3d22e9384)

## STEP 4:
## Install Jenkins 

- Open EC2 instance

- Run the below commands to install Jenkins

``` 
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
```

```
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
```

```
sudo yum upgrade
```
- Install JAVA.
```
sudo yum install fontconfig java-17-openjdk
```
- Install Jenkins
```
sudo yum install jenkins
```
- Enable the jenkins
```
sudo systemctl enable jenkins
```
- Start Jenkins service
```
sudo systemctl start jenkins
```
- Check for status
```
sudo systemctl status jenkins
```

- Copy the server public IP and add:8080 in the browser

ex:
```
192.168.119.128:8080
```
- You will get this page

![Screenshot 2023-08-04 211812](https://github.com/180172/Terraform-project-2/assets/110009356/ddebf861-d6a9-4cd2-a07d-cef38ad9be1f)

- Paste admin password

- Install suggested plugins

![Screenshot 2023-05-17 152132](https://github.com/180172/Terraform-project-2/assets/110009356/cd11b8e3-854d-47b8-85dd-5be6d84d64f8)

- Plugins are getting downloaded

![Screenshot 2023-08-05 103205](https://github.com/180172/Terraform-project-2/assets/110009356/439083cb-b95e-4959-b7bb-7bc281ff2899)

- Click On save and finish

![Screenshot 2023-08-05 103757](https://github.com/180172/Terraform-project-2/assets/110009356/d5e497ac-2377-4ac2-8220-37ae56c2cde0)


- Visit the below website if you are installing Jenkins for other Images

``` https://www.jenkins.io/doc/book/installing/ ```

## STEP 5:
### What is terraform.tfstate file?
- The terraform.tfstate file is used by Terraform to keep track of the current state of your infrastructure. It stores information about the resources that Terraform has created, their attributes, and their dependencies.

- The terraform.tfstate file may contain sensitive information, such as resource IDs, IP addresses, or secrets. Therefore, it should be stored securely and not exposed to unauthorized users.

- By default, Terraform stores the terraform.tfstate file locally in the same directory as your Terraform configuration files. However, it's recommended to use remote state storage (e.g., S3, Azure Blob Storage, or HashiCorp Consul) for production environments to enable collaboration and prevent state file corruption.

- The terraform.tfstate file may contain sensitive information, such as resource IDs, IP addresses, or secrets. Therefore, it should be stored securely and not exposed to unauthorized users. Therefore As mentioned earlier, using remote state storage (e.g., AWS S3, Azure Blob Storage, or HashiCorp Consul) is the best practice for collaborating on Terraform projects. It provides better security, versioning, and concurrent access control.

### Creating Remote-Backend.
- Login to the AWS GUI
- Search for S3-Bucket
- Click on Create a New Bucket
![Screenshot 2023-09-24 220514](https://github.com/180172/Terraform-project-2/assets/110009356/528b5cf2-8287-4c66-b27a-354af49266f6)
- Add the bucket name. The bucket name must be unique.
- Select a region and click on Create a bucket
![Screenshot 2023-09-24 220850](https://github.com/180172/Terraform-project-2/assets/110009356/ef40df9e-890c-4b3d-be94-4993a95aed86)


- Open the bucket that you have created 
- Click on Create Create folder
![Screenshot 2023-09-24 221059](https://github.com/180172/Terraform-project-2/assets/110009356/c47b766f-14f1-4398-948d-87e9b34a774c)
- Add the folder name and click on Create.

## STEP 6:
### What is state locking & Why is state locking
- Terraform uses a locking mechanism to prevent concurrent state modifications. This is crucial when working with teams to avoid conflicts and ensure data integrity.

- There is a possibility that two developers will push changes to the Terraform code when more than two developers are working on the same project. if more than one request is made simultaneously to the terraform.tfstate file. The tfstate file will become corrupted. We are using the state-locking feature to stop this.

![Screenshot 2023-09-24 223822](https://github.com/180172/Terraform-project-2/assets/110009356/ba211b13-f8ce-4368-b807-91cab05243e7)

- Terraform maintains its state file locally by default. When a terraform operation is being carried out locally, the state file is automatically locked utilizing APIs.

- All backends will not support the Terraform state-locking feature. In order to learn about the statelocking feature, we must read the documentation.

![image](https://github.com/180172/Infrastructure-as-Code-IaC-with-AWS-and-Jenkins/assets/110009356/30bec4d6-3f99-434a-8895-6bf16a1b8331)
       
- Some of the popular backends include:
- S3
- Consul
- Azurerm
- Kubernetes
- HTTP
- ETCD

### Creating DynamoDB table

- Search for DynamoDB in AWS
- Click on Create a table
  
![Screenshot 2023-09-24 224045](https://github.com/180172/Terraform-project-2/assets/110009356/4c1b61b9-1008-4d32-bced-63070416dca9)

- Add the table name
- The partition key must be "LockID" and it should be of type "String"

![Screenshot 2023-09-24 224210](https://github.com/180172/Terraform-project-2/assets/110009356/a70e6afc-f213-4181-81dd-8f3b671df2b5)

- Click on Create a table

## STEP 7:
### Create a GitHub repo

- Create a GitHub repo it might be public or private.

- Clone the repo to the EC2 instance.

- Generate the ssh-key in the EC2 instance by running the command

``` 
ssh-keygen
```

- Copy the public key and open your GitHub. On the right side corner under your profile select "Settings"

![Screenshot 2023-10-29 200347](https://github.com/180172/Terraform-project-2/assets/110009356/2afaa987-d273-4812-af50-c8f1b4c15aec)

- Select SSH and GPJ keys and click on New SSH key
- Add the ".pub_rsa" key selected from EC2 and save

## STEP 8:
### Configure the Jenkins

- Now our work is almost completed. Let's create a Jenkins job and trigger the job.
- Open the Jenkins dashboard
- Click on New Item. Enter the ITEAM name select PIPELINE and click on OK.
  
![image](https://github.com/180172/Terraform-project-2/assets/110009356/ca441d6b-ef13-42a9-accb-6eeca684d13d)

- Under General select "This project is parameterised". Name the parameter and under choices add apply and destroy. This step is used to trigger the job. When you configure the job a prompt will pop up and it will ask you if this job is running to apply the infrastructure or to destroy the infrastructure.
  
![image](https://github.com/180172/Terraform-project-2/assets/110009356/87400b37-c135-4fa2-9311-5434a65aea07)

- Select the pipeline script add a sample code and click on Pipeline Syntax
  
![image](https://github.com/180172/Terraform-project-2/assets/110009356/9c64be79-129b-4322-9ea5-72fc484e8c5f)

- Under Sample Step select Check out from the version control
  
![image](https://github.com/180172/Terraform-project-2/assets/110009356/0a6036e1-1459-4a12-80e7-629e465e7a0c)

- Select GIT and add your git repo URL
- Select the default branch
  
![image](https://github.com/180172/Terraform-project-2/assets/110009356/01f77f73-aac4-433b-ab33-95a21ed319dc)
![image](https://github.com/180172/Terraform-project-2/assets/110009356/3aefd651-cca2-4c0d-a6d9-5d5184fc46a1)

- Click on generate pipeline script and you will get a script
  
![image](https://github.com/180172/Terraform-project-2/assets/110009356/ab54afd7-2dca-42fb-b0a5-45c456e89fb7)

- Come back to your main script and add the script as shown below
  
![image](https://github.com/180172/Terraform-project-2/assets/110009356/7294f0c9-dc4c-47d1-8052-868b20732477)

- Now continue the script as shown below. The code is in GitHub repo. Click on Apply and Save.
  
![image](https://github.com/180172/Terraform-project-2/assets/110009356/07944ff1-272a-43da-b4d7-75a3f3b2346a)

## STEP 8:
### Push the code to GitHub

- Push the code to GitHub
- In the Jenkins console click on Build with Parameters.
- Select the apply and click on "Build"

![image](https://github.com/180172/Terraform-project-2/assets/110009356/3aade934-559b-4302-b5db-3370d24825e7)

- Currently, the job is running state.

![image](https://github.com/180172/Terraform-project-2/assets/110009356/4ac877f2-9a6a-4fc2-a737-d0f1276aecf0)

- The job has been successfully completed

![Uploading Screenshot 2023-10-29 205447.png…]()

![image](https://github.com/180172/Terraform-project-2/assets/110009356/15cc7a1a-d9b5-4fc1-b0c1-4bb82ef585cc)

![image](https://github.com/180172/Terraform-project-2/assets/110009356/7dd2b3ed-4bdf-46f1-a9eb-5ca83c04af76)

- Now let's destroy the infrastructure. Again click on Build with Parameters and now instead of Apply select Destroy.

![image](https://github.com/180172/Terraform-project-2/assets/110009356/f541a4aa-b995-491d-b421-f6c863c7efef)

