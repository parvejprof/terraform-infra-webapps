# Automated Deployment of Webapps in the Cloud

## Introduction

This project automates the deployment of a web application using Terraform (Infrastructure as Code) to provision AWS resources and deploy the web application inside a Docker container. By running a simple `terraform apply` command, the required AWS infrastructure and Docker container for the web application will be provisioned. This ensures secure traffic (TLS) over the internet without manual intervention, providing consistency across each deployment.

## Prerequisites

1. Obtain credentials for the target AWS environment.
2. Install `git` and `terraform` on your local machine.

## Using Terraform to Create an AWS Environment and Deploy the Webapp

### Initializing Terraform

Navigate to the Terraform configuration directory and initialize Terraform:

```sh
$ cd terraform-infra/
$ terraform init
```

### Running Terraform code

Run the following command to ensure terraform will only perform the expected actions:

```sh
$ terraform plan
```

Run the following command to apply the configuration to the target AWS Cloud environment:    
    
```sh
$ terraform apply
```

### Sanity Test 

After successfully executing terraform apply, note the output for demo-alb-dns-name, which will look something like this:

```sh
Outputs:

demo-alb-dns-name = "terraform-demo-alb-291616235.ap-south-1.elb.amazonaws.com"
```

Ensure accessibility and validate the results by visiting the following URLs:

```sh
https://terraform-demo-alb-291616235.ap-south-1.elb.amazonaws.com
https://terraform-demo-alb-291616235.ap-south-1.elb.amazonaws.com/docker
https://terraform-demo-alb-291616235.ap-south-1.elb.amazonaws.com/secret_word
https://terraform-demo-alb-291616235.ap-south-1.elb.amazonaws.com/loadbalanced
https://terraform-demo-alb-291616235.ap-south-1.elb.amazonaws.com/tls
```

### Note
The Load Balancer (demo-alb-dns-name) URL may change with each AWS provisioning. The syntax is:

https://<loadbalnacer_dns_name>
https://<loadbalnacer_dns_name>/docker
https://<loadbalnacer_dns_name>/secret_word
https://<loadbalnacer_dns_name>/loadbalanced
https://<loadbalnacer_dns_name>/tls

### Tearing Down the Terraform-managed AWS Environment

To verify the resources that will be impacted and then destroy those resources, run:

```sh
$ terraform plan
$ terraform destroy
```

## Thank you!!