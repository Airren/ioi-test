#!/bin/bash

helm install kafka-1 ./kafka-1

for ((i=1; i<=10; i++))
do
  mkdir -p ./result
  resultPath=./result/$(basename $0)-$i.log
  echo "------------ benchmark-$i: $0 --------------------"
  kubectl apply -f fio_deployment_200M_x4.yaml
  sleep 1m
  kubectl apply -f kafka-1-job.yaml
  sleep 10s
  
  kubectl wait --for=condition=complete --timeout=3600s job/kafka-client-1-job
  sleep 1m
  kubectl get po | grep kafka-client-1-job

  kubectl  get po -A |grep "kafka-client-1-job" | awk '{print $2}'| xargs -n1 kubectl logs |grep "7200000 records sent" >  $resultPath

  kubectl delete  -f fio_deployment_200M_x4.yaml
  sleep 20s
  kubectl delete jobs.batch --all
  kubectl delete po --all
  sleep 6m

done

helm delete kafka-1
