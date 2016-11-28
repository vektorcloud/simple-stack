variable "do_token" {}

variable "key_base" {
  type    = "string"
  default = "private/node"
}

variable "droplet_size" {
  type    = "string"
  default = "512mb"
}

variable "droplet_image" {
  type    = "string"
  default = "ubuntu-16-04-x64"
}

variable "droplet_region" {
  type    = "string"
  default = "nyc2"
}

provider "digitalocean" {
  token = "${var.do_token}"
}

/*
Base SSH key configuration
*/
resource "digitalocean_ssh_key" "node" {
  name       = "Node"
  public_key = "${file("${var.key_base}.pem.pub")}"
}

/*
Assign a floating IP to the node so the instance may be replaced
without affecting existing DNS configuration
*/
resource "digitalocean_floating_ip" "public" {
  droplet_id = "${digitalocean_droplet.node.id}"
  region     = "${digitalocean_droplet.node.region}"
}

/*
Creates a signle Droplet named "node"
*/
resource "digitalocean_droplet" "node" {
  name               = "node"
  region             = "${var.droplet_region}"
  size               = "${var.droplet_size}"
  image              = "${var.droplet_image}"
  private_networking = true
  ssh_keys           = ["${digitalocean_ssh_key.node.id}"]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = "${file("${var.key_base}.pem")}"
  }

  provisioner "remote-exec" {
    // Install Docker and run Nginx
    inline = [
      "curl -fLsS https://get.docker.com/ | sudo sh",
      "docker run -d -v /var/www:/var/www --restart always quay.io/vektorcloud/nginx:latest",
    ]
  }
}

output "servers" {
  value = "${digitalocean_droplet.node.ipv4_address}"
}
