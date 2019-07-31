resource "digitalocean_droplet" "haproxy-web" {
  image              = "ubuntu-16-04-x64"
  name               = "haproxy-web"
  region             = "nyc1"
  size               = "512mb"
  private_networking = true
  ssh_keys = [
    var.ssh_fingerprint,
  ]
  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "2m"
  }
  # use remote exec provisioner to install haproxy
  provisioner "remote-exec" {
    inline = [
      "sleep 25",
      "sudo apt-get update",
      "sudo apt-get -y install haproxy",
    ]
  }
  # grab data from template file defined in template.tf
  provisioner "file" {
    content = data.template_file.haproxyconf.rendered
    destination = "/etc/haproxy/haproxy.cfg"
  }
  # restart HAproxy
  provisioner "remote-exec" {
    inline = [
      "sudo service haproxy restart",
    ]
  }
}

