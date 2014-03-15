#!/bin/bash
dir=`dirname $0`
files=(`ls -l *.js|awk '{print $9}'`)
for jsfile in ${files[@]}
do
  echo "=====${jsfile}====="
  node $dir/${jsfile}
  echo ""
done

