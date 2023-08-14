

# Workflow for IO Scheduler and Isolation Testing using Kafka

## Without IO scheduler & Isolation

A the GA test Pods and noise neighbors deploy to the worknode ioi-2.

Befor this section, make sure the IOI scheduler & Isolation has been disabled.

```sh
# disable ioi scheduler & isolation
sudo ls
./disable_ioi.sh
```

### 1. Only worklaod Kafka

Initiate ***only the Critical workload Kafka*** on the designated worknode IOI-2, and execute the test 10 times using the following command:

```sh
bench-ga-kafka-only-without-ioi.sh
```

The producer process is expected to complete in over 60 minutes. Once the job is concluded, the script will automatically compute the producer's performance metrics. The resulting performance data will be stored in the `./result` directory.

### 2. Workload(Kafka) + NN(fio 200M * 4)

Initiate the ***Critical workload Kafka and Fio as noise neighbor*** on the designated worknode IOI-2, and execute the test 10 times using the following command:

```sh
bench-ga-kafka-fio-without-ioi.sh
```

The producer process is expected to complete in over 60 minutes. Once the job is concluded, the script will automatically compute the producer's performance metrics. The resulting performance data will be stored in the `./result` directory.

### 3. workload(Kafka)+Other workload(Kafka)

Initiate the ***Critical workload  Kafka and other workload Kafka*** on the designated work node IOI-2, and execute the test 10 times using the following command:

```sh
bench-ga-kafka-otherga-without-ioi.sh
```

The producer process is expected to complete in over 60 minutes. Once the job is concluded, the script will automatically compute the producer's performance metrics. The resulting performance data will be stored in the `./result` directory.

## With IO Scheduler & Isolation

Enable the IOI scheduler and Isolation

```sh
sudo ls
./enable.sh
```

### 4. GA workload(Kafka)+NN(Fio) as BE Pod + IO scheduler & Isolation

Initiate the ***Critical workload Kafka as GA Pod and Fio as BE Pod*** with IOI enabled on the designated work node IOI-2, and execute the test 10 times using the following command:

```sh
bench-ga-kafka-fio-ioi.sh
```

The producer process is expected to complete in over 60 minutes. Once the job is concluded, the script will automatically compute the producer's performance metrics. The resulting performance data will be stored in the `./result` directory.

### 5. GA workload(Kafka)+ Other GA workload(Kafka)+ IO scheduler & Isolation

Initiate the ***Critical workload Kafka as GA Pod and Other workload Kafka as GA Pod*** with IOI enabled on the designated work node IOI-2, and execute the test 10 times using the following command:

```sh
./bench-ga-kafka-otherga-ioi.sh
```

The producer process is expected to complete in over 60 minutes. Once the job is concluded, the script will automatically compute the producer's performance metrics. The resulti0ng performance data will be stored in the `./result` directory.










