#!/bin/bash
# fio_deployment_0.yaml  kafka-job.yaml

for ((i=1; i<=10; i++))
do
  echo "------------ fio as nn  ioi case$i benchmark --------------------"
  kubectl apply -f fio_deployment_ioi.yaml
  sleep 1m
  kubectl apply -f kafka-1-job.yaml
  sleep 10s
  
  sleep 1m
  kubectl wait --for=condition=complete --timeout=3600s job/kafka-client-1-job
  sleep 1m
  kubectl get po | grep kafka-client-1-job

  kubectl  get po -A |grep "kafka-client-1-job" | awk '{print $2}'| xargs -n1 kubectl logs |grep "7200000 records sent" >  ./result/bench-kafka-fio-ioi-result-20$i.log

  kubectl delete -f fio_deployment_ioi.yaml
  sleep 20s
  kubectl delete jobs.batch --all
  kubectl delete po --all
  sleep 6m

done
