# Define the variables of vpc, subnets, igw & RT which we want as outputs, to use it with other modules

output "vpc_id" {
  value = aws_vpc.testvpc.id
}

output "private_subnets_id" {
  value = aws_subnet.private_subnet[*].id
}

output "public_subnets_id" {
  value = aws_subnet.public_subnet[*].id
}

output "igw_id" {
  value = aws_internet_gateway.test_igw.id
}

output "route_table_id" {
  value = aws_route_table.test_RT.id
}
