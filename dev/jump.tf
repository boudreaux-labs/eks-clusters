data "aws_iam_role" "existing_iam_role" {
  name = "awssystemsmanagerdefaultec2instancemanagementrole"
}

resource "aws_iam_instance_profile" "boudreaux-labs-ec2-default" {
    name = "boudreaux-labs-ec2-default"
    role = data.aws_iam_role.existing_iam_role.name
}



resource "aws_instance" "jump1" {
  ami           = "ami-005f8adf84f8c5057"   
  instance_type = "t3.small"
  key_name      = "rdpkey"                  # Located in EC2, Network & Security, Key Pairs
  subnet_id = module.vpc.private_subnets[0]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.boudreaux-labs-ec2-default.name

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

resource "aws_security_group" "boudreaux-labs-ec2-default-sg" {
  name        = "boudreaux-labs-ec2-default-sg"
  description = "Allow all outbound. Allow some inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "RDP from VPC"
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks      = [module.vpc.cidr_block]
    ipv6_cidr_blocks = [module.vpc.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "boudreaux-labs-ec2-default-sg"
  }
}