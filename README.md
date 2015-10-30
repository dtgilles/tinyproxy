## introduction

------
THIS IS PRE ALPHA -- NOT TESTIFIED!
------
This is a debian based tinyproxy installation. Config file options may be set with command line
options.

If a file /etc/tinyproxy/filters exists (mount it if you need it) is will be used as "Filter" file.

## examples

 * Following command line starts a tinyproxy container: named "tiny" that proxies all your data to the internet
	docker run -d --name tiny        dtgilles/tinyproxy

 * run the same container but mount log directory to specific local location
	docker run -v /container/tinyproxy:/logs \
                   -d --name tiny        dtgilles/tinyproxy

 * run the first container but filter domains by a given list; white or black list behaviour is controlled by "-FilterDefaultDeny" (default: No)
	docker run -v /container/tinyproxy.filter:/etc/tinyproxy.filter:ro \
                   -d --name tiny        dtgilles/tinyproxy

 * you also can add any config option out of "man tinyproxy.conf (5)", but you have to precede Option with "-"
	docker run -d --name tiny        dtgilles/tinyproxy \
                   -Allow       10/8 \
                   -No Upstream 10/8 \
                   -Upstream proxy:3128
