#!/bin/bash

function truncate-docker-log-file {
  cutoff=$(date -d "now - $PERIOD days" '+%Y-%m-%d')
  echo "$(tail -n $(cat $1 | jq -r .time | awk -v cutoff="$cutoff" '$1 >= cutoff { print } ' | wc -l) $1)" > $1
}
export -f truncate-docker-log-file

echo "Truncating logs to $PERIOD days"
find /app -name '*-json.log' -exec bash -c 'truncate-docker-log-file "$0"' {} \;
