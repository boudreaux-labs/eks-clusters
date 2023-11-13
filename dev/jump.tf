resource "aws_iam_instance_profile" "my_instance_profile" {
    name = "my_instnace_profile"
    role = "arn:aws:iam::842851109414:role/service-role/AWSSystemsManagerDefaultEC2InstanceManagementRole"
}

resource "aws_instance" "jump1" {
  ami           = "ami-005f8adf84f8c5057"   
  instance_type = "t3.small"
  key_name      = "rdpkey"                  # Located in EC2, Network & Security, Key Pairs
  subnet_id = module.vpc.private_subnets[0]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.my_instance_profile
  tags = {
    Name = "jump1"
  }

  # Additional configuration for Windows instances
  user_data = <<-EOF
              <powershell>
                # PowerShell script for Windows instance setup goes here
                # For example, you can configure Windows features, install software, etc.
              </powershell>
              EOF
}

# Output the public IP address of the instance for convenience
output "jump1_public_ip" {
  value = aws_instance.jump1.public_ip
}