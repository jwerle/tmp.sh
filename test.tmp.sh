#!/usr/bin/env tmp -d ~/repos/tmp.sh/tmp

ls
ls file > /dev/null 2>&1
if (( 0 == $? )); then
  echo "ok"
else
  echo "fail"
fi
