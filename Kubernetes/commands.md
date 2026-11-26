Networking

###
ip a ->listing the connection to which its connected to i mean control plan or nodes
ip link
netstat -ntlp to check the kubernetes components are connected to what all ports
netstat -anp | grep etcd | grep 2379 | wc -l --> given the no of connections made on the etcd for port 2379
kubectl get nodes -o wide --> gives all good detials for all nodes


Cluster commands
kubectl get pods -n kube-system
we have yaml files for all components in kubernetes on /etc/kubernetes/manifests/*.yaml 

kubectl get pods -A --field-selecor=status.phase!=Running -->gives the pods which are not running

kubectl get events --sort-by=.lastTimestamp

When a pod won’t start, a deployment hangs, or something just feels “off” in the cluster, this is often one of the first commands I run.

Instead of guessing, it shows the most recent events:

• Failed image pulls
• Scheduling failures
• Probe failures
• Resource constraints
• Permission issues

kubectl get pods --all-namespaces  -gives pods in all the namespaces

kubectl expose pod redis --port=6379 --name=redis-service --type=ClusterIP
