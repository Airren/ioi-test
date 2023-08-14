#!/bin/bash
ssh cre@ioi-2 "echo 123456 | sudo -S  systemctl start ioi-emulator-service"
sudo cp /etc/kubernetes/kube-scheduler.yaml.ioi /etc/kubernetes/manifests/kube-scheduler.yaml
./clear_disk.sh

sleep 10s
