#!/bin/bash

if [ -z "$CLUSTER_NAME" ]; then
	echo "Cluster name not set"
	exit 1
elif [ -z "$MAX_SERVERS" ]; then
	echo "Max servers not set"
	exit 2
fi


INITIAL_CLUSTER=""
for i in $( seq 1 $MAX_SERVERS );do
   INITIAL_CLUSTER="$INITIAL_CLUSTER$DOCKERCLOUD_SERVICE_HOSTNAME-$i=http://$DOCKERCLOUD_SERVICE_HOSTNAME-$i:2380,"
done

RUN_COMMAND="exec /bin/etcd -name $DOCKERCLOUD_CONTAINER_HOSTNAME \
  -advertise-client-urls http://$DOCKERCLOUD_CONTAINER_FQDN:2379 \
  -listen-client-urls http://0.0.0.0:2379 \
  -initial-advertise-peer-urls http://$DOCKERCLOUD_CONTAINER_HOSTNAME:2380 \
  -listen-peer-urls http://0.0.0.0:2380 \
  -initial-cluster-token $CLUSTER_NAME \
  -initial-cluster $INITIAL_CLUSTER \
  -data-dir /data "

echo $RUN_COMMAND

$RUN_COMMAND