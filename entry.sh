#!/bin/bash

###############################################################################
# Name:         entry.sh
# Description:  Used as ENTRYPOINT from Tinyproxy's Dockerfile
# Usage:        
#               entry.sh              -- just start tinyproxy
#               entry.sh -option ...  -- start tinyproy with options
#               entry.sh cmd args     -- run another command (with arguments)
###############################################################################

PATH=$PATH:/usr/sbin

exitus()
   {
      local rc="$1"; shift
      echo "$*" >&2
      exit $rc
   }

if [ $# == 0  ] || [ $1 == -* ]
   then
      [ -r /etc/default/tinyproxy ] &&  . /etc/default/tinyproxy
      if [ -f /etc/tinyproxy.filter ]
         then
            optionsgrep="^Filter "
            echo "Filter  /etc/tinyproxy.filter"      > /tmp/tinyproxy.add
         else
            :>/tmp/tinyproxy.add
            optionsgrep=""
         fi
      while [ $# -gt 0 ]
	 do
	    case "$1"
               in
                  -Upstream)
                        if [ "$3" = "${3#-}" ]
                           then
                              echo "Upstream $2 '$3'" >> /tmp/tinyproxy.add
                              shift 3         || exitus 3 "wrong usage of '$1' -- see tinyproxy man page"
                           else
                              echo "Upstream $2"      >> /tmp/tinyproxy.add
                              shift 2         || exitus 3 "wrong usage of '$1' -- see tinyproxy man page"
                           fi
                        optionsgrep="^Upstream|$optionsgrep"
                     ;;
                  -No)	[ "$2" = "Upstream" ] || exitus 3 "unknown Option '$1 $2'"
                        optionsgrep="^No Upstream|$optionsgrep"
                        echo "No Upstream '$3'"       >> /tmp/tinyproxy.add
                        shift 3               || exitus 3 "wrong usage of '$1 $2' -- see tinyproxy man page"
                     ;;
                  -LogLevel|-Allow|-Deny|-FilterDefaultDeny|-ConnectPort)   ##### most common options
                        optionsgrep="^${1#-}|$optionsgrep"
                        echo "${1#-}  $2"             >> /tmp/tinyproxy.add
                        shift 2               || exitus 3 "wrong usage of '$1' -- see tinyproxy man page"
                     ;;
                  -*)                                                       ##### no further options check
                        optionsgrep="^${1#-}|$optionsgrep"                  ##### -- just key/value
                        echo "${1#-}  $2"             >> /tmp/tinyproxy.add
                        shift 2               || exitus 3 "wrong usage of '$1' -- see tinyproxy man page"
                     ;;
                  *)  exitus 3 "wrong usage of this container -- '$1' is not an option";;
               esac
            egrep -iv "${optionsgrep%|}" /etc/tinyproxy.conf > /etc/tinyproxy.sum
            cat                          /tmp/tinyproxy.add >> /etc/tinyproxy.sum
         done
      chown -R nobody:nogroup /logs
      set -- tinyproxy -d -c /etc/tinyproxy.sum
   fi

exec "$@"
