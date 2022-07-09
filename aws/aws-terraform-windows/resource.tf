resource "aws_instance" "winServer" {
  tags = {
    Name = var.tagname
  }
  ami                    = var.windowsAmi[var.region]
  instance_type          = var.instance_type
  key_name               = var.keyname
  vpc_security_group_ids = [aws_security_group.security_group.id]
  subnet_id              = aws_subnet.main-public-1.id
  user_data              = <<EOF
                    <powershell>
                    net user ${var.instanceUsername} '${var.instancePassword}' /add /y
                    net localgroup administrators ${var.instanceUsername} /add
                    winrm quickconfig -q
                    winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="300"}'
                    winrm set winrm/config '@{MaxTimeoutms="1800000"}'
                    winrm set winrm/config/service '@{AllowUnencrypted="true"}'
                    winrm set winrm/config/service/auth '@{Basic="true"}'
                    netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow
                    netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow
                    net stop winrm
                    sc.exe config winrm start=auto
                    net start winrm
                    </powershell>
                    EOF


  provisioner "file" {
    source      = "scripts"
    destination = "C:/windows/temp"
  }
  provisioner "remote-exec" {
    inline = [
      "powershell.exe -ExecutionPolicy Bypass -File C:/windows/temp/test.ps1"
    ]
  }
  connection {
    host     = coalesce(self.public_ip, self.private_ip)
    type     = "winrm"
    timeout  = "10m"
    user     = var.instanceUsername
    password = var.instancePassword
    https    = false
    insecure = true
  }
}
