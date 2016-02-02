## introduction

This is a debian based tinyproxy installation. Usually tinyproxy doesn't allow setting options by command line. This docker container supports that feature.

If a file /etc/tinyproxy.filter exists (mount it if you need it) then it will be used as "Filter" file. That is a white list of allowed domains. You invert the meaning to white list using "-FilterDefaultDeny Yes" or you can force interpretation as URL -- plain or as regex; see man page for more information.

## use case: develop in changing proxy environments

What can we do with such a tinyproxy? Beside the obvious use case "setup a static proxy" it could be convenient for developers. They have to switch their environment often: sometimes they work at home (without proxy), sometimes they work inside company networks (fixed proxy). These developers could configure their (docker-) applications to an instance of this docker container. And if they change their environment they just have to start this image with parameters that fit to their current network environment. It's like a proxy selector for all application at once.



## examples

 * Following command line starts a tinyproxy container: named "tiny" that proxies all your data to the internet:

        docker run -d --name tiny        dtgilles/tinyproxy

 * run the same container but mount log directory to specific local location:

        docker run -v /container/tinyproxy:/logs \
               -d --name tiny   dtgilles/tinyproxy

 * run the first container but filter requests by a given domain white list:

        docker run -v /container/tinyproxy.filter:/etc/tinyproxy.filter:ro \
               -d --name tiny   dtgilles/tinyproxy

 * but the main idea of this docker images is to enable you to set any configuration option you want -- just precede it (see man page for option list) with "-"; that's how it works:

        docker run -p           8888:8888 \
               -d --name tiny   dtgilles/tinyproxy \
               -Allow           10.0.0.0/8 \
               -No Upstream     10.0.0.0/8 \
               -No Upstream     .internal.company.com \
               -Upstream   proxy.internal.company.com:3128

 this command starts a "tiny" named container listening on port 8888 that allows connections from clients with 10/8 ip addresses; all request are sent to upstream proxy except they focus on ip range 10/8 or names out of the domain "internal.company.com"

 * if you'd like to look inside the logs try

         docker exec -it tiny tail -f /logs/tinyproxy.log

