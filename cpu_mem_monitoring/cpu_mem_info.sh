#!/bin/bash

{
  echo "Timestamp: $(date +"%d-%m-%Y %H:%M:%S")"
  echo "CPU Usage:"
  top -b -n 1 | grep "^%Cpu"
  echo "Memory Usage:"
  free -m | head -n 2
  echo "------------------------------"
} >> $HOME/Desktop/monitoring.txt
