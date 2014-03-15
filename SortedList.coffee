#package.json
#{
#  "volo": {
#    "dependencies": {
#      "sortedlist": "github:shinout/SortedList"
#    }
#  }
#}
#
((root, factory) ->
  if typeof define is "function" and define.amd
    define [], factory
  else if typeof module is "object" and module.exports
    module.exports = factory()
  else
    root.SortedList = factory()
  return
) this, ->
  
  ###
  SortedList : constructor
  ###
  SortedList = (args...)->
    arr = null
    options = {}
    [
      "0"
      "1"
    ].forEach (n) ->
      val = args[n]
      if Array.isArray(val)
        arr = val
      else options = val  if val and typeof val is "object"
      return

    @_filter = options.filter  if typeof options.filter is "function"
    if typeof options.compare is "function"
      @_compare = options.compare
    else @_compare = SortedList.compares[options.compare]  if typeof options.compare is "string" and SortedList.compares[options.compare]
    @_unique = !!options.unique
    if options.resume and arr
      arr.forEach ((v, i) ->
        @push v
        return
      ), this
    else @insert.apply this, arr  if arr
    return

  
  ###
  SortedList.create(val1, val2)
  creates an instance
  ###
  SortedList.create = (val1, val2) ->
    new SortedList(val1, val2)

  SortedList:: = new Array()
  SortedList::constructor = Array::constructor
  
  ###
  sorted.insertOne(val)
  insert one value
  returns false if failed, inserted position if succeed
  ###
  SortedList::insertOne = (val) ->
    pos = @bsearch(val)
    return false  if @_unique and @key(val, pos)?
    return false  unless @_filter(val, pos)
    @splice pos + 1, 0, val
    pos + 1

  
  ###
  sorted.insert(val1, val2, ...)
  insert multi values
  returns the list of the results of insertOne()
  ###
  SortedList::insert = (args...)->
    Array::map.call args, ((val) ->
      @insertOne val
    ), this

  
  ###
  sorted.remove(pos)
  remove the value in the given position
  ###
  SortedList::remove = (pos) ->
    @splice pos, 1
    this

  
  ###
  sorted.bsearch(val)
  @returns position of the value
  ###
  SortedList::bsearch = (val) ->
    return -1  unless @length
    mpos = undefined
    spos = 0
    epos = @length
    while epos - spos > 1
      mpos = Math.floor((spos + epos) / 2)
      mval = this[mpos]
      comp = @_compare(val, mval)
      return mpos  if comp is 0
      if comp > 0
        spos = mpos
      else
        epos = mpos
    (if (spos is 0 and @_compare(this[0], val) > 0) then -1 else spos)

  
  ###
  sorted.key(val)
  @returns first index if exists, null if not
  ###
  SortedList::key = (val, bsResult) ->
    bsResult = @bsearch(val)  unless bsResult?
    pos = bsResult
    return (if (pos + 1 < @length and @_compare(this[pos + 1], val) is 0) then pos + 1 else null)  if pos is -1 or @_compare(this[pos], val) < 0
    pos--  while pos >= 1 and @_compare(this[pos - 1], val) is 0
    pos

  
  ###
  sorted.key(val)
  @returns indexes if exists, null if not
  ###
  SortedList::keys = (val, bsResult) ->
    ret = []
    bsResult = @bsearch(val)  unless bsResult?
    pos = bsResult
    while pos >= 0 and @_compare(this[pos], val) is 0
      ret.push pos
      pos--
    len = @length
    pos = bsResult + 1
    while pos < len and @_compare(this[pos], val) is 0
      ret.push pos
      pos++
    (if ret.length then ret else null)

  
  ###
  sorted.unique()
  @param createNew : create new instance
  @returns first index if exists, null if not
  ###
  SortedList::unique = (createNew) ->
    if createNew
      return @filter((v, k) ->
        k is 0 or @_compare(this[k - 1], v) isnt 0
      , this)
    total = 0
    @map((v, k) ->
      return null  if k is 0 or @_compare(this[k - 1], v) isnt 0
      k - (total++)
    , this).forEach ((k) ->
      @remove k  if k?
      return
    ), this
    this

  
  ###
  sorted.toArray()
  get raw array
  ###
  SortedList::toArray = ->
    @slice()

  
  ###
  default filtration function
  ###
  SortedList::_filter = (val, pos) ->
    true

  
  ###
  comparison functions
  ###
  SortedList.compares =
    number: (a, b) ->
      c = a - b
      (if (c > 0) then 1 else (if (c is 0) then 0 else -1))

    string: (a, b) ->
      (if (a > b) then 1 else (if (a is b) then 0 else -1))

  
  ###
  sorted.compare(a, b)
  default comparison function
  ###
  SortedList::_compare = SortedList.compares["string"]
  SortedList

