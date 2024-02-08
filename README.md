# Terraform Test

* The `main` branch includes minimal fixes to maintain compatibility with existing code base and environment.
  * [apply.txt](https://github.com/khicks/tf-test/blob/main/apply.txt) contains evidence of a successful run.
* [PR #4](https://github.com/khicks/tf-test/pull/4) is more representative of how I would write this module scratch.
* Another option to consider would be to use the [terraform-aws-modules/vpc](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
  community repo to minimize the amount of code to write for building a simple VPC such as this.
