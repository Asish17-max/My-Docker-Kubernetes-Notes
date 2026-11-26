## Docker build
docker build -t <name of the image> /path to Dockerfile
docker build -t <name>:v1 -f Dockerfile
docker build --no-cache -t <name> .  -->best way to use

## Running docker containers using commadnline
docker run -d --name <nameof the container> <image>
docker run -d --name debug_1 -p 8080:80 nginx:apline
docker run -d --name debug_1 -p 8080:80 nginx:alpine sleep 1000 -->sleep 1000 is like CMD option in docker file

## Copy items 
docker cp <name of the container>:src location to dest location
  Example1 -->docker cp debug_1:/tmp/hi.txt /home/hi.txt
  Example2  -->docker /home/hi.txt debug_1:/tmp/

## Listing commands
docker ps -a -->gives list of all running and stopped containers as well
docker images -->gives the list of all docker images created
docker network ls -->lists all networks

## Removing Dockers
docker rm <name> 
docker image rm  <name>
docker network disconnect <name>
docker voulume rm <name>

## Docker exec
docker exec -it container_id bash
docker exec -it container_id sh

## Docker volumes
docker volume ls
docker volume create <name of the volume>
docker run -d --name app -v /opt/appdata:/app/data nginx -->binding the volume mount while running 
container.
(or)
docker run --mount type=bind,source=/opt/appdata , target=/app/data nginx


## Network
docker network create  <name>
docker network create  --driver= --subnet= <name>
docker network connect <name>

## Logs
docker logs container_id
docker logs --tail 100 container_id
docker logs -f container_id

#### Connection with ECR and push image to ECR
-->aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 240365323441.dkr.ecr.us-east-1.amazonaws.com --autentication with AWS ECR
-->docker tag devop-ecr:latest 240365323441.dkr.ecr.us-east-1.amazonaws.com/devop-ecr:latest  -->here container image is built with pyapp:latest and its tagged to ECR to the devops-ecr repo
-->docker push 240365323441.dkr.ecr.us-east-1.amazonaws.com/devop-ecr:latest  -->here the image is pushed to ECR
--.Next we create a task definition with this image and URL for ECR and specify CPU,Memory container name and the Image URI which is an arn 
-->After creating the cluster then we configure service using the task definition by giving the VPC,Subnets security grps, and Port configurations.
