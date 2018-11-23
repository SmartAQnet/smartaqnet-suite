#! /bin/bash
if test -z "$smartaqnethome"
then	echo "export smartaqnethome=$(uname -n).teco.edu" > /etc/environment
fi
source /etc/environment
# Start landoop with heap size set to 3G
docker run --net=host --name="frosty_landoop" --restart="unless-stopped" \
-d -e CONNECT_HEAP=3G -e ADV_HOST=$smartaqnethome -e RUNTESTS=0 landoop/fast-data-dev
