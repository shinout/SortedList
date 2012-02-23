SortedList
==========
sorted list in JavaScript

### Installation ###
    git clone git://github.com/shinout/SortedList.git

    OR

    npm install sortedlist

### Usage ###

    // sort number
    var list = SortedList.create();
    list.insert(13, 2, 9, 8, 0);
    console.log(list.toArray()); // [0,2,8,9,13]

    // sort string
    var arr = ["foo", "bar", "hoge"];
    var strList = SortedList.create(arr, {
      compare: "string"
    });
    console.log(strList.toArray()); // ["bar", "foo", "hoge"]

    // SortedList is not Array
    console.assert(!Array.isArray(list));

    // SortedList is instanceof Array
    console.assert(list instanceof Array);

    // SortedList extends Array
    console.assert(list[2], 8);
    console.assert(list.length, 5);
    console.assert(list.pop(), 13);

    // register an already sorted array
    var list = SortedList.create(0,1,2,3,4, { resume: true });

### MORE ###
sort ranges with no overlap

    var list = SortedList.create([
      [152, 222],  // 4
      [33, 53],    // 2
      [48, 96],    // duplicated, so filtered.
      [928, 1743], // 5
      [66, 67],    // 3
      [11, 12]     // 1
    ],
    {
      // filter function: called before insertion.
      filter: function(val, pos) {
        return (this[pos]   == null || (this[pos]   != null && this[pos][1]  <  val[0])) 
          && 
               (this[pos+1] == null || (this[pos+1] != null && val[1] < this[pos+1][0]));
      },

      // comparison function called before insertion.
      compare: function(a, b) {
        if (a == null) return -1;
        if (b == null) return  1;
        var c = a[0] - b[0];
        return (c > 0) ? 1 : (c == 0)  ? 0 : -1;
      }
    });

    console.log(list.toArray());
    /* [
      [ 11, 12 ],
      [ 33, 53 ],
      [ 66, 67 ],
      [ 152, 222 ],
      [ 928, 1743 ]
    ] */

