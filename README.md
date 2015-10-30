## introduction

------
THIS IS PRE ALPHA -- NOT TESTIFIED!
------
This is a debian based tinyproxy installation. Usually tinyproxy doesn't allow setting options by command line. This docker container supports that feature.

If a file /etc/tinyproxy.filter exists (mount it if you need it) then it will be used as "Filter" file. That is a white list of allowed domains. You invert the meaning to white list using "-FilterDefaultDeny Yes" or you can force interpretation as URL -- plain or as regex; see man page for more information.

## examples

 * Following command line starts a tinyproxy container: named "tiny" that proxies all your data to the internet:
	docker run -d --name tiny        dtgilles/tinyproxy

 * run the same container but mount log directory to specific local location:
	docker run -v /container/tinyproxy:/logs \
                   -d --name tiny        dtgilles/tinyproxy

 * run the first container but filter requests by a given domain white list:
	docker run -v /container/tinyproxy.filter:/etc/tinyproxy.filter:ro \
                   -d --name tiny        dtgilles/tinyproxy

 * you also can add any config option out of "man tinyproxy.conf (5)", but you have to precede Option with "-":
    	docker run -d --name tiny        dtgilles/tinyproxy \
                       -Allow       10/8 \
                       -No Upstream 10/8 \
                       -Upstream proxy.company:3128
