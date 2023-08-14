#!/bin/bash

rootpath="/home/cre/IOIsolation"

#cd $rootpath
#make all && sudo make image && sudo make push_to_repo

echo "Clear and ready env"
# clear test workloads
sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
kubectl get pods | grep -v NAME | awk '{print $1}' | grep fio | xargs kubectl delete pod

# clear node agent and CR
kubectl delete -f $rootpath/deployments/node-agent-daemonset.yaml
kubectl delete nodediskiostatusinfoes.ioi.intel.com ioi-1-nodediskiostatusinfo -n ioi-system
kubectl delete nodediskiostatusinfoes.ioi.intel.com ioi-2-nodediskiostatusinfo -n ioi-system
kubectl delete nodediskiostatusinfoes.ioi.intel.com ioi-3-nodediskiostatusinfo -n ioi-system
kubectl delete nodediskioinfoes.ioi.intel.com ioi-1-nodediskioinfo -n ioi-system
kubectl delete nodediskioinfoes.ioi.intel.com ioi-2-nodediskioinfo -n ioi-system
kubectl delete nodediskioinfoes.ioi.intel.com ioi-3-nodediskioinfo -n ioi-system

declare -a arr=(
   "config/crd/bases/ioi.intel.com_nodediskioinfoes.yaml"
   "config/crd/bases/ioi.intel.com_nodediskiostatusinfoes.yaml"
   "hack/all-in-one.yaml"
   "deployments/rbac/agent-clusterrole.yaml"
   "deployments/rbac/agent-service-account.yaml"
   "deployments/rbac/agent-clusterrolebinding.yaml"
   "deployments/admin-configmap.yaml"
   "deployments/policy-configmap.yaml"
)

## now loop through the above array
for i in "${arr[@]}"; do
   echo "$rootpath"/"$i"
   kubectl delete -f "$rootpath"/"$i"
   kubectl apply -f "$rootpath"/"$i"
   # or do whatever with individual element of the array
done

# stop ioi service
echo "stop ioi service"
ssh cre@ioi-1 "echo 123456 | sudo -S systemctl stop ioi-emulator-service"
ssh cre@ioi-2 "echo 123456 | sudo -S systemctl stop ioi-emulator-service"
ssh cre@ioi-3 "echo 123456 | sudo -S systemctl stop ioi-emulator-service"
# reboot scheduler
echo "reboot scheduler"
if sudo grep -q "v=4" /etc/kubernetes/manifests/kube-scheduler.yaml; then
   sudo sed -i 's/--v=4/--v=5/g' /etc/kubernetes/manifests/kube-scheduler.yaml
   echo "v=4 to v=5"
elif sudo grep -q "v=5" /etc/kubernetes/manifests/kube-scheduler.yaml; then
   sudo sed -i 's/--v=5/--v=4/g' /etc/kubernetes/manifests/kube-scheduler.yaml
   echo "v=5 to v=4"
else
   echo "v not found"
fi

# launch ioi service
echo "launch ioi service on worker nodes"
ssh cre@ioi-1 "echo 123456 | sudo -S systemctl start ioi-emulator-service"
ssh cre@ioi-2 "echo 123456 | sudo -S systemctl start ioi-emulator-service"
ssh cre@ioi-3 "echo 123456 | sudo -S systemctl start ioi-emulator-service"

# apply node agent
kubectl apply -f $rootpath/deployments/node-agent-daemonset.yaml

