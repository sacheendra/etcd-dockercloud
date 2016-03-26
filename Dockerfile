#
# Dockerfile for running etcd on Dockercloud
#

FROM alpine:3.3
MAINTAINER Sacheendra Talluri <sacheendra.t@gmail.com>

ENV			ETCD_VERSION v2.3.0

ENV			CLUSTER_NAME MAX_SERVERS

RUN			apk add --update ca-certificates openssl tar && \
			wget https://github.com/coreos/etcd/releases/download/$ETCD_VERSION/etcd-$ETCD_VERSION-linux-amd64.tar.gz && \
			tar xzvf etcd-$ETCD_VERSION-linux-amd64.tar.gz && \
			mv etcd-$ETCD_VERSION-linux-amd64/etcd* /bin/ && \
			apk del --purge tar openssl && \
			rm -Rf etcd-$ETCD_VERSION-linux-amd64* /var/cache/apk/*

VOLUME		/data

EXPOSE		2379 2380

ADD			start.sh /bin/start.sh

ENTRYPOINT	["/bin/start.sh"]