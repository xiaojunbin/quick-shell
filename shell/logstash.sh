#!/bin/bash

cd /opt/logstash

nohup ./bin/logstash -f ./logstash.conf --config.reload.interval 30s -r &