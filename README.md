SortedList
==========
sorted list in JavaScript

### Installation ###
    git clone git://github.com/shinout/SortedList.git

    OR

    npm install sortedlist

### Usage ###

    // sort number
    var list = new SortedList();
    list.insert(13, 2, 9, 8, 0);
    console.log(list.toArray()); // [0,2,8,9,13]

    // sort string
    var arr = ["foo", "bar", "hoge"];
    var strList = new SortedList(arr, {
      compare: "string"
    });
    console.log(strList.toArray()); // ["bar", "foo", "hoge"]


### MORE ###
sort ranges with no overlap

    var list = new SortedList([
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
        if (isNull)
        return (this.arr[pos]   == null || (this.arr[pos]   != null && this.arr[pos][1]  <  val[0])) 
          && 
               (this.arr[pos+1] == null || (this.arr[pos+1] != null && val[1] < this.arr[pos+1][0]));
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

