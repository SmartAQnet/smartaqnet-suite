FROM postgres:10
MAINTAINER BowenWang <wang@teco.edu> 
# Install prerequirements 
ENV POSTGIS_MAJOR 2.4
ENV POSTGIS_VERSION 2.4.4+dfsg-4.pgdg90+1

RUN echo "Running dockerfile"

RUN apt-get update \
      && apt-cache showpkg postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR \
      && apt-get install -y --no-install-recommends \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts=$POSTGIS_VERSION \
           postgis=$POSTGIS_VERSION \
      && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /docker-entrypoint-initdb.d
# Copy scripts for setting up postgis
ADD scripts/initdb-postgis.sh /docker-entrypoint-initdb.d/1.postgis.sh
ADD scripts/update-postgis.sh /usr/local/bin

# install wal-e
RUN apt-get update && apt-get install -y vim python3-pip python-dev lzop pv daemontools
RUN python3 -m pip install wal-e[aws] 

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Copy scripts that configures wal-e
ADD scripts/docker-entrypoint.sh /docker-entrypoint.sh
ADD scripts/fix-acl.sh /docker-entrypoint-initdb.d/
ADD scripts/setup-wale.sh /docker-entrypoint-initdb.d/

# Expose port so that it can be accessed from other container or application
EXPOSE 5432
