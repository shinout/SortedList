/**
 * SortedList : constructor
 * 
 * @param arr : Array or null : an array to set
 *
 * @param options : object  or null
 *         (function) filter  : filter function called before inserting data.
 *                              This receives a value and returns true if the value is valid.
 *
 *         (function) compare : fucntion to compare two values, 
 *                              which is used for sorting order.
 *                              the same signiture as Array.prototype.sort(fn).
 *                              
 *         (string)   compare : if you'd like to set a common comparison function,
 *                              you can specify it by string:
 *                              "number" : compares number
 *                              "string" : compares string
 */
function SortedList() {
  var arr     = null,
      options = {},
      args    = arguments;

  ["0","1"].forEach(function(n) {
    var val = args[n];
    if (Array.isArray(val)) {
      arr = val;
    }
    else if (val && typeof val == "object") {
      options = val;
    }
  });
  this.arr = [];

  ["filter", "compare"].forEach(function(k) {
    if (typeof options[k] == "function") {
      this[k] = options[k];
    }
    else if (options[k] && SortedList[k][options[k]]) {
      this[k] = SortedList[k][options[k]];
    }
  }, this);
  if (arr) this.insert.apply(this, arr);
};

/**
 * SortedList.create(val1, val2)
 * creates an instance
 **/
SortedList.create = function(val1, val2) {
  return new SortedList(val1, val2);
};

/**
 * sorted.bsearch(val)
 * @returns position of the value
 **/
SortedList.prototype.bsearch = function(val) {
  var mpos,
      spos = 0,
      epos = this.arr.length;
  while (epos - spos > 1) {
    mpos = Math.floor((spos + epos)/2);
    mval = this.arr[mpos];
    switch (this.compare(val, mval)) {
    case 1  :
    default :
      spos = mpos;
      break;
    case -1 :
      epos = mpos;
      break;
    case 0  :
      return mpos;
    }
  }
  return (this.arr[0] == null || spos == 0 && this.arr[0] != null && this.compare(this.arr[0], val) == 1) ? -1 : spos;
};

/**
 * sorted.get(pos)
 * gets value of the given position
 **/
SortedList.prototype.get = function(pos) {
  return this.arr[pos];
};

/**
 * sorted.toArray()
 * get raw array
 **/
SortedList.prototype.toArray = function(reference) {
  return (reference) ? this.arr : this.arr.slice();
};

/**
 * sorted.size()
 * get length of the array
 **/
SortedList.prototype.size = function() {
  return this.arr.length;
};

/**
 * sorted.head()
 * gets the first value
 **/
SortedList.prototype.head = function() {
  return this.arr[0];
};

/**
 * sorted.tail()
 * gets the last value
 **/
SortedList.prototype.tail = function() {
  return (this.arr.length == 0) ? null : this.arr[this.arr.length -1];
};

/**
 * sorted.insertOne(val)
 * insert one value
 * returns false if failed, inserted position if succeed
 **/
SortedList.prototype.insertOne = function(val) {
  var pos = this.bsearch(val);
  if (!this.filter(val, pos)) return false;
  this.arr.splice(pos+1, 0, val);
  return pos+1;
};

/**
 * sorted.insert(val1, val2, ...)
 * insert multi values
 * returns the list of the results of insertOne()
 **/
SortedList.prototype.insert = function() {
  return Array.prototype.map.call(arguments, function(val) {
    this.insertOne(val);
  }, this);
};

/**
 * sorted.add(val1, val2, ...)
 * alias of sorted.insert()
 **/
SortedList.prototype.add = SortedList.prototype.insert;

/**
 * sorted.delete(pos)
 * remove the value in the given position
 **/
SortedList.prototype.delete = function(pos) {
  this.arr.splice(pos, 1);
};

/**
 * sorted.remove(pos)
 * remove the value in the given position
 **/
SortedList.prototype.remove = SortedList.prototype.delete;

/**
 * filter
 **/
SortedList.prototype.filter = function(val, pos) {
  return true;
};


/**
 * default compare functions 
 **/
SortedList.compare = {
  "number": function(a, b) {
    var c = a - b;
    return (c > 0) ? 1 : (c == 0)  ? 0 : -1;
  },

  "string": function(a, b) {
    return (a > b) ? 1 : (a == b)  ? 0 : -1;
  }
};

/**
 * sorted.compare(a, b)
 **/
SortedList.prototype.compare = SortedList.compare["number"];

if (typeof exports == 'object' && exports === this) module.exports = SortedList;
