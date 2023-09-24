# Automated Infrastructure Management with Ansible and Terraform
 In this project we are deploying 2-Ansible remote machines & 1-control node.
We are installing 2 Ansible remote machines and 1 control node for this project. Python is being installed on 2 remote nodes and the Ansible software is on the control node. The "terraform. tfstate" file is kept in off-site storage. We utilize AWS S3 to store remote states. DynamoDB is the database we're using for state locking.

## Prerequsite 

- AWS account

- IAM user with S3 & EC2 full access

- Terraform software 

If you dont have terraform software visit below terraform offical web-site.

```
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
```

## STEP 1:
### What is terraform.tfstate file?
- The terraform.tfstate file is used by Terraform to keep track of the current state of your infrastructure. It stores information about the resources that Terraform has created, their attributes, and their dependencies.

- The terraform.tfstate file may contain sensitive information, such as resource IDs, IP addresses, or secrets. Therefore, it should be stored securely and not exposed to unauthorized users.

- By default, Terraform stores the terraform.tfstate file locally in the same directory as your Terraform configuration files. However, it's recommended to use remote state storage (e.g., S3, Azure Blob Storage, or HashiCorp Consul) for production environments to enable collaboration and prevent state file corruption.

- The terraform.tfstate file may contain sensitive information, such as resource IDs, IP addresses, or secrets. Therefore, it should be stored securely and not exposed to unauthorized users. Therefore As mentioned earlier, using remote state storage (e.g., AWS S3, Azure Blob Storage, or HashiCorp Consul) is the best practice for collaborating on Terraform projects. It provides better security, versioning, and concurrent access control.

### Creating Remote-Backend.
- Login to the AWS GUI
- Search for S3-Bucket
- Click on create new bucket
![Alt text](image-3.png)
- Add the bucket name. Bucket name must be unique.
- Select region and click on Create bucket
![Alt text](image-4.png)

- Open the bucket which you have created 
- Click on create Create folder
![Alt text](<Screenshot 2023-09-24 221059.png>)
- Add the folder name and click on create.

## STEP 2:
### What is state locking & Why is state locking
- Terraform uses a locking mechanism to prevent concurrent state modifications. This is crucial when working with teams to avoid conflicts and ensure data integrity.

- There is a possibility that two developers will push changes to the Terraform code when more than two developers are working on the same project. if more than one request is made simultaneously to the terraform.tfstate file. The tfstate file will become corrupted. We are using the state-locking feature to stop this.


- Terraform maintains its state file locally by default. When a terraform operation is being carried out locally, the state file is automatically locked utilizing APIs.

- All backends will not support the Terraform state-locking feature. In order to learn about the statelocking feature, we must read the documentation.

![Alt text](image-5.png)
- Some of the popular backends include:
- S3
- Consul
- Azurerm
- Kubernetes
- HTTP
- ETCD

### Creating DynamoDB table

- Search for DynamoDB in AWS
- Click on Create table
![Alt text](<Screenshot 2023-09-24 224045.png>)

- Add the table name
- Partition key must be "LockID" & It should be of type "String"

![Alt text](<Screenshot 2023-09-24 224210.png>)

- Click on Create table

## STEP 3:
- Create a folder and get inside that folder
Let's create our 1st file
- backend.tf
- main.tf

- In main.tf "private_key" you have to add your .pem key with .pem extension (Ex: Jekins.pem)

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
