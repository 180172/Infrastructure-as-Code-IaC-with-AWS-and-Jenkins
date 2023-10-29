# Infrastructure as Code (IaC) with AWS and Jenkins

### This project showcases the implementation of Infrastructure as Code (IaC) using Terraform, AWS, and Jenkins to automate the provisioning of remote Ansible nodes and a control node. The infrastructure is designed for Ansible automation, facilitating system configuration and management. Below are the key components and features of this project:

## Prerequisite 

- AWS account
 
- IAM-Roll with S3, DynamoDB & EC2 full access

- Terraform software 

If you don't have Terraform software visit below Terraform official website below.

```
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
```

## STEP 1:

#### Create EC2 instance:
- Click on Create EC2 instance

![Alt text](image-7.png)

- Select Amazon Linux 2 Image

![Alt text](image-8.png)

- Instance type should be "t2.micro" and select key-pair

![Alt text](image-9.png)

- Select VPC and subnets

![Alt text](image-11.png)

- Create a new security group. Allow SSH and All traffic Anywhere 

![Alt text](image-12.png)

- Add storage of 15GB for storage

![Alt text](image-13.png)

- Click on Create instance

## STEP 2:
### Create IAM role

- Open IAM console

![Alt text](<Screenshot 2023-10-29 174037.png>)

- Select "AWS service"

![Alt text](image-14.png)

![Alt text](image-15.png)

- Click on next

- Under "Add permissions" select EC2Full Access, S3Full Access, and DynamoDBFull Access

- Add name and click on Create role

## STEP 3:

### Attach IAM policy to EC2 Instance

- Select the Instance that you created

- Under Actions => Security => Modify IAM role.

![Alt text](image-16.png)

- Select IAM role that you created and click on Update IAM role

![Alt text](image-17.png)

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

![Alt text](<Screenshot 2023-08-04 211812.png>)

- Paste admin password

- Install suggested plugins

![Alt text](<Screenshot 2023-05-17 152132.png>)

- Plugins are getting downloaded

![Alt text](image-18.png)

- Click On save and finish

![Alt text](image-19.png)



- Visit the below website if you are installing jenkins for other Images

``` https://www.jenkins.io/doc/book/installing/ ```


## STEP 1:
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

## STEP 2:
### What is state locking & Why is state locking
- Terraform uses a locking mechanism to prevent concurrent state modifications. This is crucial when working with teams to avoid conflicts and ensure data integrity.

- There is a possibility that two developers will push changes to the Terraform code when more than two developers are working on the same project. if more than one request is made simultaneously to the terraform.tfstate file. The tfstate file will become corrupted. We are using the state-locking feature to stop this.


- Terraform maintains its state file locally by default. When a terraform operation is being carried out locally, the state file is automatically locked utilizing APIs.

- All backends will not support the Terraform state-locking feature. In order to learn about the statelocking feature, we must read the documentation.

![Screenshot 2023-09-24 223822](https://github.com/180172/Terraform-project-2/assets/110009356/ba211b13-f8ce-4368-b807-91cab05243e7)
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

## STEP 3:
- Create a folder and get inside that folder
Let's create our 1st file
- backend.tf
- main.tf

- In main.tf "private_key" you have to add your .pem key with .pem extension (e.g.: Jekins.pem)

- In main.tf "key_name" you have to add your key name only without .pem
(Ex: Jenkins)

After saving both the file in a folder. Inside the folder itself run 
```
terraform init
```
- Once terraform initialized run 
```
terraform plan
```
- Now run 
```
terraform apply -auto-approve
```

- Once testing is done delete the resources by running
```
terraform destroy -auto-approve
```
