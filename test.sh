#!/bin/bash
# fio_deployment_0.yaml  kafka-job.yaml
# for ((i=1; i<=2; i++)) do
#   echo "------------ bench case$i benchmark --------------------"
#   kubectl apply -f kafka-job.yaml
#   kubectl wait --for=condition=complete --timeout=3600s job/kafka-client-job
#   kubectl get po | grep kafka-client-job
#   
#   kubectl  get po -A |grep "kafka-client-job" | awk '{print $2}'| xargs -n1 kubectl logs |grep "7200000 records sent" >  ./result/bench-result-10$i.log
#   
#   sleep 20s
#   kubectl delete -f kafka-job.yaml
#   kubectl delete po --all
#   sleep 5m
# 
# done
# 
# for ((i=1; i<=2; i++))
# do
#   echo "------------ 10M -> 5M  cgroup limit  case$i benchmark --------------------"
#   kubectl apply -f fio_deployment_10M_5M.yaml
#   sleep 20s
#   kubectl apply -f kafka-job.yaml
#   kubectl wait --for=condition=complete --timeout=3600s job/kafka-client-job
#   kubectl get po | grep kafka-client-job
#   
#   kubectl  get po -A |grep "kafka-client-job" | awk '{print $2}'| xargs -n1 kubectl logs |grep "7200000 records sent" >  ./result/b-5m-result-10$i.log
#   
#   kubectl delete -f fio_deployment_10M_5M.yaml
#   sleep 20s
#   kubectl delete -f kafka-job.yaml
#   kubectl delete po --all
#   sleep 5m
# 
# done
# 



for ((i=1; i<=2; i++))
do
  echo "------------ 20M -> 10M  ioi case$i benchmark --------------------"
  kubectl apply -f fio_deployment_20M_10M.yaml
  sleep 20s
  kubectl apply -f kafka-job.yaml
  kubectl wait --for=condition=complete --timeout=3600s job/kafka-client-job
  kubectl get po | grep kafka-client-job
  
  kubectl  get po -A |grep "kafka-client-job" | awk '{print $2}'| xargs -n1 kubectl logs |grep "7200000 records sent" >  ./result/b-10m-result-10$i.log
  
  kubectl delete -f fio_deployment_20M_10M.yaml
  sleep 20s
  kubectl delete -f kafka-job.yaml
  kubectl delete po --all
  sleep 5m

done

for ((i=1; i<=2; i++))
do
  echo "------------ 50M -> 20M  ioi case$i benchmark --------------------"
  kubectl apply -f fio_deployment_50M_20M.yaml
  sleep 20s
  kubectl apply -f kafka-job.yaml
  kubectl wait --for=condition=complete --timeout=3600s job/kafka-client-job
  kubectl get po | grep kafka-client-job
  
  kubectl  get po -A |grep "kafka-client-job" | awk '{print $2}'| xargs -n1 kubectl logs |grep "7200000 records sent" >  ./result/b-20m-result-10$i.log
  
  kubectl delete -f fio_deployment_50M_20M.yaml
  sleep 20s
  kubectl delete -f kafka-job.yaml
  kubectl delete po --all
  sleep 10m

done
