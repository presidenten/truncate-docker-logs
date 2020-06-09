# truncate-docker-logs

Removes docker container log entries that are older than `$PERIOD` amount of days.

Helps fulfil business requirements where logs may not be older than a certain amount of days.

## What it does

Docker has some log rotation options, but they are based on file size.

This docker container parses docker logs and figures out how many log entries should be kept from the end of each logfile to ensure only logs from `$PERIOD` days are saved.
Effectively giving a sliding window of logs that can always be accessed through docker and kubernetes cli, while still fulfilling business requirements on how many days of logging may be present at any one time.

## Prerequisites

Docker engine setup with `{ "log-driver": "json-file" }`

## Usage

The docker container needs to run on every node in the cluster.

In kubernetes this is handled by a `DaemonSet` with tolerations that accepts most taints.

A Kubernetes yaml file is available in `./kubernetes/truncate-logs-daemonset.yaml`.

The yaml-file has a few values that can be adjusted to taste. The most common ones are available in a ConfigMap at the top of the yaml file:
- The amount of days to keep logs
- The cronjob configuration (default is every night at 02:00)

If needed - the path of the docker logs is available under volumes, and resources may be increased of lowered.

## Cons

Log entries may be lost if a log entry is made at the exact same time as the log file is being written to disk.
Minimize the risk by running the cronjob when there is usually low traffic.

This script processes and truncates all the docker log files on the nodes to keep only `$PERIOD` amount of days worth of logs. Even system container logs.
