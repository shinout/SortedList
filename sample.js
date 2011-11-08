var SortedList = require("./SortedList");

function test() {
  // sample : ranges with no overlap
  var list = new SortedList([
    [152, 222], [33, 53], [48, 96], [928, 1743], [66, 67], [11, 12]
  ],
  {
    filter: function(val, pos) {
      return (this.arr[pos]   == null || (this.arr[pos]   != null && this.arr[pos][1]  <  val[0])) 
        && 
             (this.arr[pos+1] == null || (this.arr[pos+1] != null && val[1] < this.arr[pos+1][0]));
    },
    compare: function(a, b) {
      if (a == null) return -1;
      if (b == null) return  1;
      var c = a[0] - b[0];
      return (c > 0) ? 1 : (c == 0)  ? 0 : -1;
    }
  });


  console.log(list.toArray());
}


test();
