resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "eks_cluster_ingress" {
  type              = "ingress"
  description       = "Ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "SSH"
  cidr_blocks       = ["10.0.101.0/24", "10.0.102.0/24"]
  security_group_id = aws_security_group.eks_cluster_sg.id
}
resource "aws_security_group_rule" "egress_https" {
  type              = "egress"
  description       = "Egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"] # VPC CIDR
  security_group_id = aws_security_group.eks_cluster_sg.id
}
