#!/bin/bash
helm install kafka-1 ./kafka-1
helm install kafka-2 ./kafka-2
helm install kafka-3 ./kafka-3
helm install kafka-4 ./kafka-4

for ((i=1; i<=10; i++))
do
  mkdir -p ./result
  resultPath=./result/$(basename $0)-$i.log
  echo "------------ benchmark-$i: $0 --------------------"
  kubectl apply -f kafka-1-job.yaml
  sleep 10s

  kubectl apply -f kafka-2-job.yaml
  sleep 10s
  kubectl apply -f kafka-3-job.yaml
  sleep 10s
  kubectl apply -f kafka-4-job.yaml
  sleep 1m
  
  kubectl wait --for=condition=complete --timeout=3600s job/kafka-client-1-job
  sleep 1m
  kubectl get po | grep kafka-client-1-job

  kubectl  get po -A |grep "kafka-client-1-job" | awk '{print $2}'| xargs -n1 kubectl logs |grep "7200000 records sent" >  $resultPath

  kubectl delete jobs.batch --all
  kubectl delete po --all
  sleep 6m

done

helm delete kafka-1
helm delete kafka-2
helm delete kafka-3
helm delete kafka-4
