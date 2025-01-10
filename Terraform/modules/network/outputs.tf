output "esky-public-subnet-ID" {
    value = aws_subnet.esky_public_subnet.id
}

output "esky-private-subnet-ID" {
    value = aws_subnet.esky_private_subnet.id
}

output "public-nic-ID" {
    value = aws_network_interface.public_nic.id
}

output "private-nic-ID" {
    value = aws_network_interface.private_nic.id
}