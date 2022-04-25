#!/bin/bash

chmod 777 /conf/kibana/kibana.02.yml

docker-compose -f /opt/docker-yml/kibana/kibana.02.yml up -d