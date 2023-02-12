eks_cluster_name = "ex-apigee"
eks_cluster_version = "1.24"
eks_node_group_max_size = 7
eks_node_group_min_size = 1
eks_node_group_desired_size = 2
eks_node_group_instance_types = ["m6i.xlarge"]

k8s_admins = ["eks-aigee-hbelgacem","eks-aigee-mmelo"]

vpc_cidr = "10.0.0.0/16"
tags = {
    Example    = "ex-apigee"
    CreatedBy = "HBE"
    Org = "OneSkill"
}
