#!/bin/sh

# inotifywait: Start/Stop inotifywait
#
# description: Delete the contain in cache folder in a SugarCRM Instance
#
# author: Carlos Zaragoza  <carloszaragoza@outook.com>
# processname: inotifywait

echo "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RETVAL=0
start() {
MONITORDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
inotifywait -e create,delete,modify,move -mrq "${MONITORDIR}/custom" | grep '\.js$' --line-buffered |
while read path events file; do
   echo "$events $file in $path Deleting cache folder"
   rm -rf $MONITORDIR/cache/*
done
}
stop() {
   echo -n $"Stopping inotifywait: "
   killproc inotifywait
   RETVAL=$?
   echo
   [ $RETVAL -eq 0 ] && rm -f $LOCK
   return $RETVAL
}
case "$1" in
   start)
      start
      ;;
   stop)
      stop
      ;;
   status)
      status inotifywait
      ;;
   restart)
      stop
      start
      ;;
   *)
      echo $"Usage: $0 {start|stop|status|restart}"
      exit 1
esac
exit $?
