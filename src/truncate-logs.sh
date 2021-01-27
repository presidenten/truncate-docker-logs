#!/bin/bash

function clean-docker-log-file {
  if [[ -v DEBUG ]]
  then
    echo Cleaning logs: " " $1
  fi

  # Remove weird characters
  sed -i $'s/[^[:print:]\t]//g' $1

  # Remove wild empty lined
  sed -i '/^$/d' $1
}
export -f clean-docker-log-file

function truncate-docker-log-file {
  if [[ -v DEBUG ]]
  then
    echo Truncating logs: $1
  fi
  cutoff=$(date -d "now - $PERIOD days" '+%Y-%m-%d')
  logwindow=$(cat $1 | jq -r .time | awk -v cutoff="$cutoff" '$1 >= cutoff { print } ' | wc -l)
  echo "$(tail -n $logwindow $1)" > $1
}
export -f truncate-docker-log-file

echo "Truncating logs to $PERIOD days"
find /app -name '*-json.log' -exec bash -c 'clean-docker-log-file "$0"; truncate-docker-log-file "$0"' {} \;
