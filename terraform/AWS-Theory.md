
### VPC Peering Connection btw 2 VPC 
-->One VPC is connected with IGW and One VPC is private no IGW attached there are 2 EC2 in both of them I want to ping to EC2 in Private VPC then I will do it from Public VPC EC2
-->In VPC Peering we have Accepter and Requester So Requester becomes our Public VPC and Accepter is Private VPC we do this 1st and create a VPC Perring with name and req once Private VPC accepts it 
-->We update the route tables each VPC has their route tables so for Private VPC route we allow traffic from Public VPC CIDR(Destinationa) and Target is VPC Peering ID and for Public VPC route table we get traffic from Privatw VPC CIDR range(Destination) and target is VPC Peering ID.
-->In order to get connection for EC2 for public EC2 we should have allowed SSH for it from anywhere and for Private EC2 Sg we should put ICMP port from Pulic VPC CIDR range

### Implementing Auto Scaling for HA
-->So first we basiacally create an launch template or take an ready to use AMI and create a launch template.
-->After creating launch template we create the ASG we give all options and at on place it asks for load balancer attachment there 
-->We need to create an ALB with req sg and create a target group with ports req and select instanaces  since after creating ASG we get instances na from that launch template so ingnore it target grp will automatically take it up once ASG is spun up.
--.Now with desired min and max capacity create an ASG attach the load balancer created and wait until TG is healthy and ALB is serving traffic.
