#!/bin/bash
# fio_deployment_0.yaml  kafka-job.yaml
# for ((i=1; i<=10; i++))
# do
#   echo "------------ bench  ioi case$i benchmark --------------------"
#   #kubectl apply -f fio_deployment_80M_8M.yaml
#   #sleep 1m
#   kubectl apply -f sysbench-job.yaml
#   kubectl wait --for=condition=complete --timeout=3600s job/sysbench-job
#   kubectl get po | grep sysbench-job
# 
#   kubectl  get po -A |grep "sysbench-job" | awk '{print $2}'| xargs -n1 kubectl logs |tail -n 30 >  ./result/bench-rocksdb-result-10$i.log
# 
#   #kubectl delete -f fio_deployment_80M_8M.yaml
#   #sleep 20s
#   kubectl delete -f sysbench-job.yaml
#   # kubectl delete po --all
#   sleep 6m
# 
# done
# 
# for ((i=1; i<=10; i++))
# do
#   echo "------------ 200M -> 20M  ioi case$i benchmark --------------------"
#   kubectl apply -f fio_deployment_80M_8M.yaml
#   sleep 1m
#   kubectl apply -f sysbench-job.yaml
#   kubectl wait --for=condition=complete --timeout=3600s job/sysbench-job
#   kubectl get po | grep sysbench-job
# 
#   kubectl  get po -A |grep "sysbench-job" | awk '{print $2}'| xargs -n1 kubectl logs |tail -n 30 >  ./result/bench-rocksdb-20m-result-10$i.log
# 
#   kubectl delete -f fio_deployment_80M_8M.yaml
#   sleep 20s
#   kubectl delete -f sysbench-job.yaml
#   # kubectl delete po --all
#   sleep 6m
# 
# done

for ((i=1; i<=10; i++))
do
  echo "------------ 200M  ioi case$i benchmark --------------------"
  kubectl apply -f fio_deployment_80M_8M.yaml
  sleep 1m
  kubectl apply -f sysbench-job.yaml
  kubectl wait --for=condition=complete --timeout=3600s job/sysbench-job
  kubectl get po | grep sysbench-job

  kubectl  get po -A |grep "sysbench-job" | awk '{print $2}'| xargs -n1 kubectl logs |tail -n 30 >  ./result/bench-rocksdb-201m-result-10$i.log

  kubectl delete -f fio_deployment_80M_8M.yaml
  sleep 20s
  kubectl delete -f sysbench-job.yaml
  # kubectl delete po --all
  sleep 6m

done
