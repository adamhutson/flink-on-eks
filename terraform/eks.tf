resource "aws_eks_cluster" "eks" {
  name     = var.project-name
  role_arn = aws_iam_role.eks-role.arn
  vpc_config {
    subnet_ids = [
      aws_subnet.vpc-private-subnet-1.id,
      aws_subnet.vpc-private-subnet-2.id,
      aws_subnet.vpc-private-subnet-3.id,
    ]
  }
}

data "aws_iam_policy_document" "assume-role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks-role" {
  name               = "eks-role-${var.project-name}"
  assume_role_policy = data.aws_iam_policy_document.assume-role.json
}

resource "aws_iam_role_policy_attachment" "eks-role-policy-attachment-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-role.name
  depends_on = [aws_iam_role.eks-role]
}

resource "aws_iam_role_policy_attachment" "eks-role-policy-attachment-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks-role.name
  depends_on = [aws_iam_role.eks-role]
}
