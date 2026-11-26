resource "aws_iam_role" "eks-cluster-role" {
    name = "eks-cluster-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "eks.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_role_policy_attchment" "eks-cluster-role-attach" {
    role = aws_iam_role.eks-cluster-role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "eks-nodegroup-role" {
    name = "eks-nodegroup-role"
    assume_role_policy = jsonencode ({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "eks-worker-node-policy" {
    role = aws_iam_role.eks-nodegroup-role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks-cni-policy" {
    role = aws_iam_role.eks-nodegroup-role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
resource "aws_iam_role_policy_attachment" "eks-registry-policy" {
    role = aws_iam_role.eks-nodegroup-role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_cluster" "my_eks" {
    name = "my-eks-cluster"
    role_arn = aws_iam_role.eks-cluster-role.arn
    vpc_config {
        subnet_ids = module.networking.private_subnet_ids
    }
    depends_on = [ aws_iam_role_policy_attchment.eks-cluster-role-attach ]


}

resource "aws_eks_node_group" "eks_nodegroup" {
    cluster_name = aws_eks_cluster.my_eks.name
    node_group_name = "my-node-group"
    node_role_arn = aws_iam_role.eks-nodegroup-role.arn
    subnet_ids = module.networking.private_subnet_ids
    scaling_config {
        desired_size = 2
        max_size = 3
        min_size = 1
    }
    instance_types = [ "t2.micro" ]
    depends_on = [
        aws_iam_role_policy_attachment.eks-worker-node-policy,
        aws_iam_role_policy_attachment.eks-cni-policy,
        aws_iam_role_policy_attachment.eks-registry-policy
    ]
}

terraform {
    backend "s3" {
        bucket = "my-terraform-state-bucket"
        key = "eks/terraform.tfstate"
        region = "us-west-2"
    }
}
