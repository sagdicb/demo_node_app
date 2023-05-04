aws iam get-role --role-name ecsTaskExecutionRole --query Role.Arn --output text

aws ecs register-task-definition --family firstTaskDef-Name --network-mode awsvpc --requires-compatibilities FARGATE --cpu 512 --memory 1024 --execution-role-arn arn:aws:iam::695245654172:role/ecsTaskExecutionRole --container-definitions '[{"name":"demo_node_app","image":"695245654172.dkr.ecr.eu-west-1.amazonaws.com/base-ecr:latest","essential":true,"portMappings":[{"containerPort":5001,"hostPort":5001}]}]'

aws ecs run-task --cluster base-cluster --task-definition firstTaskDef-Name --network-configuration "awsvpcConfiguration={subnets=[subnet-09434ec983282bbe8],securityGroups=[sg-0958d640c7780ca4b]}"

aws iam create-role --role-name FargateTaskRole --assume-role-policy-document "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"ecs-tasks.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
aws iam create-role --role-name fargateExecutionrole2 --assume-role-policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"ecs-tasks.amazonaws.com"},"Action":"sts:AssumeRole"}]}' --region eu-west-1

aws iam attach-role-policy --role-name FargateTaskRole --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy
aws iam attach-role-policy --role-name fargateExecutionrole2 --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy

aws ecs create-fargate-profile --cluster base-cluster --name base-fargate-profile --subnet-ids subnet-09434ec983282bbe8 subnet-00f9232a29bbdea59 --security-group-ids sg-0958d640c7780ca4b --task-role-arn arn:aws:iam::695245654172:role/FargateTaskRole --execution-role-arn arn:aws:iam::695245654172:role/fargateExecutionrole

aws ecs create-fargate-profile --cluster base-cluster --name base-fargate-profile --subnets subnet-09434ec983282bbe8,subnet-00f9232a29bbdea59 --security-group sg-0958d640c7780ca4b --task-role-arn arn:aws:iam::695245654172:role/FargateTaskRole --execution-role-arn arn:aws:iam::695245654172:role/fargateExecutionrole

aws ecs create-fargate-profile --cluster base-cluster --name base-fargate-profile --subnet-ids subnet-09434ec983282bbe8 subnet-00f9232a29bbdea59 --security-group-ids sg-0958d640c7780ca4b --task-role-arn arn:aws:iam::695245654172:role/FargateTaskRole --execution-role-arn arn:aws:iam::695245654172:role/fargateExecutionrole

aws ecs create-fargate-profile \
    --cluster base-cluster \
    --name base-fargate-profile \
    --subnets <comma-separated-subnet-ids> \
    --security-group <security-group-id> \
    --execution-role-arn <execution-role-arn> \
    --platform-version <fargate-platform-version> \
    --region <aws-region>

aws ecs describe-fargate-profiles --cluster base-cluster --fargate-profile-names base-fargate-profile --region eu-west-1
