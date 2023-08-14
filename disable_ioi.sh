#!/bin/bash
set -x 
ssh cre@ioi-2 "echo 123456 | sudo -S systemctl stop ioi-emulator-service"
sudo cp /etc/kubernetes/kube-scheduler.yaml /etc/kubernetes/manifests/kube-scheduler.yaml
sleep 10s
