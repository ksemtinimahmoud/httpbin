# httpbin

Running httpbin on two ec2 instances in AWS.

## Prerequisites
- [AWS-CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
- [Terraform](https://www.terraform.io/downloads.html)

## Code structure
```
.
├── Makefile                                # Makefile to run terraform
├── README.md                               # README file
├── main.tf                                 # Main terraform script
├── modules                                 # Terraform modules
│   ├── backend                             # Defines s3 bucket to store the remote file state
│   │   ├── backend.tf
│   └── ec2-httpbin                         # Creates the needed ec2 machines running httpbin 
│       ├── main.tf
│       ├── outputs.tf
│       ├── sg.tf
│       └── variables.tf
├── outputs.tf                              # To get the IPs of the created machines
├── provider.tf                             # Define the AWS provider
├── terraform.tf                            # Specify the use of s3 remote state file
└── tf-bin                                  # Terraform binaries for all OS
    ├── darwin
    │   └── terraform
    ├── linux-x64
    │   └── terraform
    ├── update_terraform.sh
    └── winx64
        └── terraform.exe
```

## Technical choices
### Terraform binary
Terraform binary files for OSX, Linux, and Windows are stored in this repository. This will allow the use of the same Terraform version within the team.

### Make commands
There is a Makefile that provides all the needed Terraform commands. The Makefile uses the Terraform binaries from this repo. __So make sure to only apply changes using make commands.__

### State management
- S3 bucket **com.httpbin.terraform.state** to store the state of the environment remotely to make the repo used by multiple developers.
- DynamoDB for locking.

## How to  Start
- Create a new IAM user with Admin access in the AWS console (with access keys).
- Set an aws profile called **httpbin** in ~/.aws with the credentials from the previous step (Manually or via `aws configure`).
- To initialize the environment the _first_ time run :
  ```bash
  make tf-first-init
  ```
This will create the s3 and dynamodb to store the state file. Later, if you made changes to the Terraform code and want to init, you can simply use:
  ```bash
  make tf-init
  ```
- Terraform plan
  ```bash
  make tf-plan
  ```
- Terraform apply
  ```bash
  make tf-apply
  ```

