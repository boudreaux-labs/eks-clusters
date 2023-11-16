output "restricted_internet_facing_albs" {
  value = aws_security_group.alb_whitelisting.id
}


