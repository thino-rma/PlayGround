#!/bin/bash

while /bin/true; do
  date "+%Y-%m-%d %H:%M:%S"
  sleep $(($RANDOM % 10 + 1))
done
