// from data.js
var tableData = data;
// code
var tableBody = d3.select("tbody");

data.forEach(function(ufoSighting) {

  var row = tableBody.append("tr");

  Object.entries(ufoSighting).forEach(function([key, value]) {

    var cellValue = tableBody.append("td");

    cellValue.text(value);

  });
});

var btnPress = d3.select("#filter-btn");

 btnPress.on("click", function() {

   d3.event.preventDefault();

   d3.select(".summary").html("");

   var dateTime = d3.select("#datetime");

   var dateValue = dateTime.property("value");

   var filter = tableData.filter(tableData => tableData.datetime === dateValue);

   filter.forEach((dateData) => {

     var row = tableBody.append("tr");

     Object.entries(dateData).forEach(([key, value]) => {

       var cellValue = tableBody.append("td");

       cellValue.text(value);

     });
   });
 });