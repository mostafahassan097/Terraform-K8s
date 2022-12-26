 resource "aws_eks_node_group" "worker-node-group" {
  cluster_name  = aws_eks_cluster.my-eks-cluster.name
  node_group_name = "eks-workernodes"
  node_role_arn  = aws_iam_role.ng-iam-role.arn
  subnet_ids   = [aws_subnet.private-1.id, aws_subnet.private-2.id, aws_subnet.private-3.id]
  instance_types = ["t2.micro"]
  ami_type = "AL2_x86_64"
  disk_size = 20
 
  scaling_config {
   desired_size = 5
   max_size   = 7
   min_size   = 3
  }
 
  depends_on = [
   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
   aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
   aws_iam_role_policy_attachment.EC2InstanceProfileForImageBuilderECRContainerBuilds
  ]
 }

  