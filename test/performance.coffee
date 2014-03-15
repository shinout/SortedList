require 'coffee-script/register'
tcolor = require("termcolor").define
currentVersion = require("../package.json").version
oldVersion = "0.3.1"
SortedLists = {}
SortedLists[oldVersion]     = require "./SortedList-0.3.1.js"
SortedLists[currentVersion] = require "../SortedList.coffee"

resultDB = require("jsrel").use __dirname + "/performance.json",
  schema:
    result:
      operation: true
      version: true
      length: 1
      time: 1
  storage: "mock"


compare = (a, b) ->
  (if a.val > b.val then 1 else -1)

limits = [200, 500, 1000, 2000, 10000, 20000]

for limit in limits
  console.log "limit", limit
  for version, SortedList of SortedLists
    console.log "\tversion", version
    list = SortedList.create(compare: compare)

    # insert
    start = new Date
    list.insert {id: i, val:Math.random()} for i in [0...limit]
    time = new Date - start
    result = resultDB.ins "result",
      operation : "insertion"
      version   : version
      length    : limit
      time      : new Date - start
    console.log "\t\t", "insertion", result.time, "sec"

    # push
    list = SortedList.create(compare: compare)
    list.push {id: i, val:Math.random()} for i in [0...limit]
    #list = list.sort(compare)
    list = list.sort()
    result = resultDB.ins "result",
      operation : "pushing"
      version   : version
      length    : limit
      time      : new Date - start
    console.log "\t\t", "pushing", result.time, "sec"

###
# show results
###
# old vs current 
console.log "==================================================="
console.log "=========   COMPARING OLD AND CURRENT ============="
console.log "==================================================="

console.log ["operation", "length", oldVersion, currentVersion, "#{oldVersion}/#{currentVersion}"].join("\t")
for operation in ["insertion", "pushing"]
  for length in limits
    rs = resultDB.find "result", {operation: operation, length: length}, {order: "version"}
    continue if rs.length isnt 2
    cur = if rs[0].version is oldVersion then rs[1] else rs[0]
    old = if rs[0].version is oldVersion then rs[0] else rs[1]

    rate = Math.round(old.time*1000/cur.time)/1000
    color = if rate>=1 then "green" else "red"
    console[color] [operation, length, old.time, cur.time, rate].join("\t")

