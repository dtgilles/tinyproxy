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

if [ $# == 0  ] || [ "${1#-}" != "$1" ]             ##### in case of no argument or if first argment is an option
   then                                             ##### (begins with "-") then start tinyproxy
      [ -r /etc/default/tinyproxy ] &&  . /etc/default/tinyproxy
      if [ -f /etc/tinyproxy.filter ]
         then
            optionsgrep="^Filter "
            echo "Filter  /etc/tinyproxy.filter"      > /tmp/tinyproxy.add
         else
            :>/tmp/tinyproxy.add
            optionsgrep="there is nothing to grep"
         fi
      while [ $# -gt 0 ]
         do
            case "$1"
               in
                  -[Uu]pstream)
                        if [ $# -gt 2 ] && [ "$3" = "${3#-}" ]
                           then
                              echo "Upstream $2 \"$3\"" >> /tmp/tinyproxy.add
                              shift 3         || exitus 3 "wrong usage of '$1' -- see tinyproxy man page"
                           else
                              echo "Upstream $2"        >> /tmp/tinyproxy.add
                              shift 2         || exitus 3 "wrong usage of '$1' -- see tinyproxy man page"
                           fi
                        optionsgrep="^Upstream|$optionsgrep"
                     ;;
                  -[Nn][Oo])  [ "$2" = "Upstream" ] || exitus 3 "unknown Option '$1 $2'"
                        optionsgrep="^No Upstream|$optionsgrep"
                        echo "no upstream \"$3\""       >> /tmp/tinyproxy.add
                        shift 3               || exitus 3 "wrong usage of '$1 $2' -- see tinyproxy man page"
                     ;;
                  -LogLevel|-Allow|-Deny|-FilterDefaultDeny|-ConnectPort)   ##### most common options
                        optionsgrep="^${1#-}|$optionsgrep"
                        echo "${1#-}  $2"               >> /tmp/tinyproxy.add
                        shift 2               || exitus 3 "wrong usage of '$1' -- see tinyproxy man page"
                     ;;
                  -*)                                                       ##### no further options check
                        optionsgrep="^${1#-}|$optionsgrep"                  ##### -- just key/value
                        echo "${1#-}  $2"               >> /tmp/tinyproxy.add
                        shift 2               || exitus 3 "wrong usage of '$1' -- see tinyproxy man page"
                     ;;
                  *)  exitus 3 "wrong usage of this container -- '$1' is not an option";;
               esac
         done
      egrep -iv "${optionsgrep%|}" /etc/tinyproxy.conf   > /logs/tinyproxy.conf
      cat                          /tmp/tinyproxy.add   >> /logs/tinyproxy.conf
      chown -R nobody:nogroup /logs
      set -- tinyproxy -d -c /logs/tinyproxy.conf
   fi

exec "$@"
