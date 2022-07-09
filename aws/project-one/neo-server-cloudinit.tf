data "template_file" "init-script" {
  template = file("neo-server/init.cfg")
  vars = {
    REGION = var.region
  }
}

data "template_file" "shell-script" {
  template = file("neo-server/script.sh")
}

data "template_cloudinit_config" "cloudinit-neo-server" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.init-script.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script.rendered
  }
}
