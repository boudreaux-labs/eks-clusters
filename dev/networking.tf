## Set Networking Configuration
#

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["General Use VPC"]
  }
}

data "aws_subnet" "eks_subnet_1" {
  filter {
    name   = "tag:Name"
    values = ["${var.stack} Private Subnet 1"]
  }
  vpc_id = data.aws_vpc.selected.id
}

data "aws_subnet" "eks_subnet_2" {
  filter {
    name   = "tag:Name"
    values = ["${var.stack} Private Subnet 2"]
  }
  vpc_id = data.aws_vpc.selected.id
}

data "aws_subnet" "eks_subnet_3" {
  filter {
    name   = "tag:Name"
    values = ["${var.stack} Private Subnet 3"]
  }
  vpc_id = data.aws_vpc.selected.id
}

#
## End Networking Configuration
