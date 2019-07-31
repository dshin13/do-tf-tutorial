data "template_file" "haproxyconf" {
  # store HAproxy template as a Terraform attribute
  template = file("${path.module}/config/haproxy.cfg.tpl")

  # assign environmental vars with private IP of server instances
  vars = {
    web1_priv_ip = digitalocean_droplet.web1.ipv4_address_private
    web2_priv_ip = digitalocean_droplet.web2.ipv4_address_private
  }
}
