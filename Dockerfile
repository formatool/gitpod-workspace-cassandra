# Source code on https://github.com/gitpod-io/workspace-images/tree/master/full
FROM gitpod/workspace-full:latest

USER root

# RUN apt-get update \
#     && apt-get upgrade -y --no-install-recommends \
#     && apt-get install -y --no-install-recommends libjemalloc2 numactl  \
#     && apt-get clean all -y \
#     && rm -rf \
#       /var/cache/debconf/* \
#       /var/lib/{apt,dpkg,cache,log} \
#       /tmp/* \
#       /var/tmp/*

# Workaround: /usr/bin/cassandra looking for wrong libjemalloc.so file
# https://issues.apache.org/jira/browse/CASSANDRA-15767
# RUN libjemalloc="$(readlink -e /usr/lib/*/libjemalloc.so.2)" \
# 	&& ln -sT "$libjemalloc" /usr/local/lib/libjemalloc.so \
# 	&& ldconfig

ENV CASSANDRA_HOME /opt/cassandra
ENV CASSANDRA_CONF /etc/cassandra

COPY --chown=gitpod:gitpod --from=cassandra ${CASSANDRA_HOME} ${CASSANDRA_HOME}
COPY --chown=gitpod:gitpod --from=cassandra ${CASSANDRA_CONF} ${CASSANDRA_CONF}

RUN chown -R gitpod:gitpod $CASSANDRA_HOME $CASSANDRA_CONF \
    && chmod 777 -R $CASSANDRA_HOME $CASSANDRA_CONF

# Create folders
RUN (for dir in /var/lib/cassandra \
                /var/log/cassandra \
                /config ; do \
        mkdir -p $dir && chown -R gitpod:gitpod $dir && chmod 777 $dir ; \
    done )

ENV PATH $CASSANDRA_HOME/bin:$PATH

USER gitpod