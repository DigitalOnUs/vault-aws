# vault-aws
A vault cluster using consul as backend

## Prerequisites
* Get [Terraform][1]
* AWS credentials and a pem file

## Usage
1. Update the `terraform.tfvars` file with your AWS credentials:

    ```
    access_key = my_AWS_access_key
    secret_key = my_AWS_secret_key
    ssh_key_name = name_of_my_PEM_file_for_AWS
    ```
2. Move your pem file to the root of the project
3. Execute terraform
    ```
    $ terraform apply
    ```
    
__Useful commands__
- `git update-index --assume-unchanged terraform.tfvars`

## Specs
* Consul 0.7.5
* Vault 0.7.0
* t2.micro x2

## TODO
* Apply best practices
* HA cluster

## Inspiration
* [aws-consul-vault/terraform][2]
* [vault-aws][3]
* [consul-aws][4]

[1]: https://www.terraform.io/
[2]: https://github.com/hashicorp/atlas-examples/tree/master/vault
[3]: https://github.com/hashicorp/vault/tree/master/terraform/aws
[4]: https://github.com/hashicorp/consul/tree/master/terraform/aws
