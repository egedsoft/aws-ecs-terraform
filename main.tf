module "ecs" {
    source = "./modules/ecs"
    cluster_name = "ecs1"
    vpc_id = "vpc-07a36c154820569c6"
    subnets_id_list = [
        "subnet-044da566f786ff9d8",
        "subnet-0d6798ff335801c6d",
        "subnet-0ea06995e19b2eebb"
    ]

}