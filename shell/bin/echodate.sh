#!/bin/bash

count=1

while /bin/true; do
  date +'%Y-%m-%d %H:%M:%S'
  count=$((++count))
  if [ ${count} -gt 5 ]; then
      break
  fi
  sleep $(($RANDOM % 5))
done
