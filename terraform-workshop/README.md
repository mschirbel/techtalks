# Terraform Workshop

## Requirements

2. Install TfSwitch and Terraform.

To install TfSwitch, [follow this link](https://tfswitch.warrensbox.com/Install/).
To install Terraform(if you can't install TfSwitch), [follow this link](https://www.terraform.io/downloads.html).

Use version 1.0.0 of Terraform.

## Running your Terraform

To run you terraform code, make sure you are logged in the AWS Account.

To open a shell with `aws-vault`:

```
aws-vault list
aws-vault exec <PROFILE_NAME>
terraform init
terraform plan
terraform apply
```

If you are having problems with session timeout, you can run you commands as such:

```
aws-vault exec <PROFILE_NAME> --no-session -- terraform init
aws-vault exec <PROFILE_NAME> --no-session -- terraform plan
aws-vault exec <PROFILE_NAME> --no-session -- terraform apply
```

## Destroy everything

In the end of each exercice, don't forget to destroy everything.

```
terraform destroy
# or
aws-vault exec <PROFILE_NAME> --no-session -- terraform destroy
```

## Links that might help

- [Resources in the AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources)
- [Terraform Documentation for S3 Bucket](https://www.terraform.io/docs/providers/aws/r/s3_bucket.html)
- [Terraform Documentation for EC2 Instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
- [Terraform Documentation for ALB](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb)
- [Terraform Documentation for AutoScaling Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group)
- [Terraform init](https://www.terraform.io/docs/cli/commands/init.html)
- [Terraform plan](https://www.terraform.io/docs/cli/commands/plan.html)
- [Terraform apply](https://www.terraform.io/docs/cli/commands/apply.html)
- [Terraform destroy](https://www.terraform.io/docs/cli/commands/destroy.html)
- [Userdata Example](https://www.bogotobogo.com/DevOps/Terraform/Terraform-terraform-userdata.php)
- [Userdata with Parameters](https://faun.pub/terraform-ec2-userdata-and-variables-a25b3859118a)
- [Terraform Generate Random Number](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer)
- [Using a .tfvars file](https://oracle-base.com/articles/misc/terraform-variables)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
- [Terraform Best Practices for AWS](https://github.com/ozbillwang/terraform-best-practices)
