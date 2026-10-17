
# Additional public subnets for EKS across two Availability Zones.
# The existing subnet in ap-south-1a is preserved.

resource "aws_subnet" "eks_public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.20.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name                                    = "${var.project_name}-eks-public-b"
    "kubernetes.io/role/elb"                = "1"
    "kubernetes.io/cluster/trend-store-eks" = "shared"
  }
}

resource "aws_subnet" "eks_public_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.20.3.0/24"
  availability_zone       = "ap-south-1c"
  map_public_ip_on_launch = true

  tags = {
    Name                                    = "${var.project_name}-eks-public-c"
    "kubernetes.io/role/elb"                = "1"
    "kubernetes.io/cluster/trend-store-eks" = "shared"
  }
}

resource "aws_route_table_association" "eks_public_b" {
  subnet_id      = aws_subnet.eks_public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "eks_public_c" {
  subnet_id      = aws_subnet.eks_public_c.id
  route_table_id = aws_route_table.public.id
}
