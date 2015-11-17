## introduction

This is a debian based tinyproxy installation. Usually tinyproxy doesn't allow setting options by command line. This docker container supports that feature.

If a file /etc/tinyproxy.filter exists (mount it if you need it) then it will be used as "Filter" file. That is a white list of allowed domains. You invert the meaning to white list using "-FilterDefaultDeny Yes" or you can force interpretation as URL -- plain or as regex; see man page for more information.

## examples

 * Following command line starts a tinyproxy container: named "tiny" that proxies all your data to the internet:

        docker run -d --name tiny        dtgilles/tinyproxy

 * run the same container but mount log directory to specific local location:

        docker run -v /container/tinyproxy:/logs \
               -d --name tiny   dtgilles/tinyproxy

 * run the first container but filter requests by a given domain white list:

        docker run -v /container/tinyproxy.filter:/etc/tinyproxy.filter:ro \
               -d --name tiny   dtgilles/tinyproxy

 * but the clou is that you can set any configuration option out of "man tinyproxy.conf (5)", if you precede it with "-":

        docker run -d --name tiny        dtgilles/tinyproxy \
               -p               8888:8888 \
               -Allow           10.0.0.0/8 \
               -No Upstream     10.0.0.0/8 \
               -No Upstream     .internal.company.com \
               -Upstream   proxy.internal.company.com:3128

 this command starts a "tiny" named container listening on port 8888 that allows connections from clients with 10/8 ip addresses; all request are sent to upstream proxy except they focus on ip range 10/8 or names out of the domain "internal.company.com"

 * if you'd like to look inside the logs try

         docker exec -it tiny tail -f /logs/tinyproxy.log

