#!/bin/bash
# fio_deployment_0.yaml  kafka-job.yaml

for ((i=1; i<=10; i++))
do
  echo "------------ 200M -> 20M  ioi case$i benchmark --------------------"
  # kubectl apply -f fio_deployment_80M_8M.yaml
  #sleep 1m
  kubectl apply -f kafka-job.yaml
  kubectl wait --for=condition=complete --timeout=3600s job/kafka-client-job
  kubectl get po | grep kafka-client-job

  kubectl  get po -A |grep "kafka-client-job" | awk '{print $2}'| xargs -n1 kubectl logs |grep "7200000 records sent" >  ./result/bench-0-ioi-result-10$i.log

  # kubectl delete -f fio_deployment_80M_8M.yaml
  # sleep 20s
  kubectl delete -f kafka-job.yaml
  kubectl delete po --all
  sleep 10m

done
