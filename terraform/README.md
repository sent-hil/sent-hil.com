# sent-hil.com terraform

Terraform scripts to create the following:
* VPC
* 2 private subnets
* 1 public subnet
* 1 RDS managed postgres instance in private subnet
* 1 dokku installed Ubuntu 16.04 instance in public subnet
* Security groups, instance static ip etc.

## Dependencies

* Requires terraform ~> 2.69
* AWS keypair already created in AWS.
* Modify variables.tf.sample and move it to variables.tf.

## Run

* terraform init
* terraform plan
* terraform apply

## Variables

* Name of project
* AWS keypair name, you can change this in variables.tf#8
