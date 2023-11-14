resource "aws_iam_instance_profile" "dev-resources-iam-profile" {
  name = "ec2_profile"
  role = aws_iam_role.dev-resources-iam-role.name
}
resource "aws_iam_role" "dev-resources-iam-role" {
  name        = "dev-ssm-role"
  description = "The role for the developer resources EC2"
  assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": {
    "Effect": "Allow",
    "Principal": {"Service": "ec2.amazonaws.com"},
    "Action": "sts:AssumeRole"
    }
    }
    EOF
}

resource "aws_iam_role_policy_attachment" "dev-resources-ssm-policy" {
role       = aws_iam_role.dev-resources-iam-role.name
policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}



#The Instance
resource "aws_instance" "jump1" {
  ami           = "ami-005f8adf84f8c5057"   
  instance_type = "t3.small"
  key_name      = "rdpkey"                  # Located in EC2, Network & Security, Key Pairs
  subnet_id = module.vpc.private_subnets[0]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.dev-resources-iam-profile.name
  vpc_security_group_ids = [aws_security_group.boudreaux-labs-ec2-default-sg.id]

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

#Security group for the instance
resource "aws_security_group" "boudreaux-labs-ec2-default-sg" {
  name        = "boudreaux-labs-ec2-default-sg"
  description = "Allow all outbound. Allow some inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "RDP from VPC"
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks      = ["${var.cidr_block}"]
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

# Output the public IP address of the instance for convenience
output "jump1_public_ip" {
  value = aws_instance.jump1.public_ip
}

