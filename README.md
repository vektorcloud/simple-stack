# docker-simple

[![circleci][circleci]](https://circleci.com/gh/vektorcloud/simple-stack)

The simplest stack. *docker-simple* launches a single DigitalOcean Droplet, assigns a public IP address, and installs Docker.

### Prerequisites

You must have an account with [DigitalOcean](https://www.digitalocean.com/) and generate an
API token. You can generate an API token in the [console](https://cloud.digitalocean.com/settings/api/tokens).
It is assumed you have an environment variable named `$DIGITALOCEAN_TOKEN` throughout the rest of this
tutorial.

### Launching

To launch the stack begin by generating a private/public SSH key.
The public key will be will be uploaded to the Droplet and configured
as the `root` user.

    ssh-keygen -b 4092 -q -N "" -f private/node.pem

Execute `terraform plan` to validate your configuration.

    terraform plan -var "do_token=$DIGITALOCEAN_TOKEN"

Apply the configuration and launch the Droplet. If all goes well 
you will see `Apply Complete!` at the end.

    # Apply the configuration
    terraform apply -var "do_token=$DIGITALOCEAN_TOKEN"
    Apply complete!


Once the stack has been launched you can use Terraform to see the public IP address of 
the server and connect via SSH.

    terraform output

    servers = 107.170.20.34

    ssh -i private/node.pem root@107.170.20.34




[circleci]: https://img.shields.io/circleci/build/gh/vektorcloud/simple-stack?color=1dd6c9&logo=CircleCI&logoColor=1dd6c9&style=for-the-badge "simple-stack"
