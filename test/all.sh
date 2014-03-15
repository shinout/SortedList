#!/bin/bash
dir=`dirname $0`
files=(`ls -l ${dir}/*.js |awk '{print $9}'`)
for jsfile in ${files[@]}
do
  echo "=====${jsfile}====="
  node ${jsfile}
  echo ""
done
coffee ${dir}/performance.coffee
