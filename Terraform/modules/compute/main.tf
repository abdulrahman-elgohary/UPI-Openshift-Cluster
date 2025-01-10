#Create an Ec2  
resource "aws_instance" "esky-ec2" {
  ami           = data.aws_ami.ubuntu_22.id
  instance_type = var.instance_type
  key_name      = var.instance_key

  #Adjust the size of Storage
  root_block_device {
    volume_size = 100
    volume_type = "gp3"
  }

  # Attach the primary (public) network interface
  network_interface {
    network_interface_id = var.public_nic_id
    device_index        = 0
  }

  # Attach the secondary (private) network interface
  network_interface {
    network_interface_id = var.private_nic_id
    device_index        = 1
  }

  tags = {
    Name = "esky-ec2"
  }
}




