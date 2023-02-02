# aws-ecs-terraform

#### Question 1 What does Terraform do?

Answer 1: This **Terraform** code creates an Amazon Web Services (AWS) infrastructure. The infrastructure consists of the following components:-

- Virtual Private Cloud (VPC)
- Security groups for the Application Load Balancer (ALB) and the Amazon Elastic Container Service (ECS)
- ALB
- IAM role for ECS task execution
- ECS cluster and service
- Auto-scaling group
- Amazon CloudWatch

#### Question 2 How does Terraform do all this?

- The code uses multiple Terraform modules to manage each component of the infrastructure. The modules are located in the `./modules directory.`

- The data source aws_vpc is used to retrieve information about the selected VPC using the `var.vpc_id variable`. The data source `aws_region` is used to retrieve information about the current AWS region.

- The modules sg_alb and sg_ecs create the security groups for the ALB and ECS, respectively. The security group configurations *include inbound and outbound rules*, such as the protocol and port number, for incoming and outgoing network traffic.

- This terraform uses `existing vpc and subnets`

- The module alb creates the ALB, and its configuration includes the VPC ID, security group list, subnet ID list, and application name. The iam module creates an IAM role for the ECS task execution.

- The ecs module creates an ECS cluster and service. The configurations include the cluster and service name, the number of application containers, the application image, the application port, the execution role ARN, and the Fargate resource requirements. The autoscale module creates an auto-scaling group for the ECS cluster.

- The cloudwatch module creates an **Amazon CloudWatch**.

## Contributing Guidelines   
Thanks for considering contributing to this project! To ensure a smooth and efficient process for both contributors and maintainers, please follow the [guidelines](CONTRIBUTING.md).
