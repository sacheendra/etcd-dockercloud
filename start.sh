#!/bin/bash

if [ -z "$CLUSTER_NAME" ]; then
	echo "Cluster name not set"
	exit 1
elif [ -z "$MAX_SERVERS" ]; then
	echo "Max servers not set"
	exit 2
fi


INTIAL_CLUSTER=""
for i in $( eval echo {1..$MAX_SERVERS});do
   INTIAL_CLUSTER="$INTIAL_CLUSTER $DOCKERCLOUD_CONTAINER_HOSTNAME=http://$DOCKERCLOUD_CONTAINER_HOSTNAME:2380,"
done

RUN_COMMAND="exec /bin/etcd -name $DOCKERCLOUD_CONTAINER_HOSTNAME \
  -advertise-client-urls https://$DOCKERCLOUD_CONTAINER_HOSTNAME:2379 \
  -listen-client-urls https://0.0.0.0:2379 \
  -initial-advertise-peer-urls http://$DOCKERCLOUD_CONTAINER_HOSTNAME:2380 \
  -listen-peer-urls http://0.0.0.0:2380 \
  -initial-cluster-token $CLUSTER_NAME \
  -initial-cluster $INTIAL_CLUSTER \
  -trusted-ca-file /etcd-init/ca.crt \
  -cert-file /etcd-init/cert_chain.crt \
  -key-file /etcd-init/discovery1_dec.key \
  -data-dir /data "

echo $RUN_COMMAND

$RUN_COMMAND