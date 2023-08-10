#!/bin/bash
set -x

for ((i=1; i<=5; i++))
do
  echo "------------ rocksdb  with out ioi case$i benchmark --------------------"
  kubectl apply -f kafka-2-job.yaml
  sleep 10s
  kubectl apply -f kafka-3-job.yaml
  sleep 10s

  kubectl apply -f sysbench-job.yaml
  kubectl wait --for=condition=complete --timeout=3600s job/sysbench-job
  kubectl get po | grep sysbench-job

  kubectl  get po -A |grep "sysbench-job" | awk '{print $2}'| xargs -n1 kubectl logs |tail -n 30 >  ./result/bench-rocksdb-nn-result-10$i.log

  sleep 20s
  kubectl delete -f sysbench-job.yaml
  kubectl delete jobs.batch --all
  kubectl delete po --all
  sleep 10m

done

for ((i=1; i<=5; i++))
do
  echo "------------ rocksdb with  ioi case$i benchmark --------------------"
  kubectl apply -f kafka-2-job.yaml
  sleep 10s

  kubectl apply -f sysbench-job.yaml
  kubectl wait --for=condition=complete --timeout=3600s job/sysbench-job
  kubectl get po | grep sysbench-job

  kubectl  get po -A |grep "sysbench-job" | awk '{print $2}'| xargs -n1 kubectl logs |tail -n 30 >  ./result/bench-rocksdb-ioi-result-10$i.log

  sleep 20s
  kubectl delete -f sysbench-job.yaml
  kubectl delete jobs.batch --all
  kubectl delete po --all
  sleep 10m

done
