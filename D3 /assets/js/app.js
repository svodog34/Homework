// @TODO: YOUR CODE HERE!

/*
You need to create a scatter plot between two of the data variables such as
 `Healthcare vs. Poverty` or `Smokers vs. Age`.

Using the D3 techniques we taught you in class, create a scatter plot that 
represents each state with circle elements. You'll code this graphic in the 
`app.js` file of your homework directory—make sure you pull in the data from 
`data.csv` by using the `d3.csv` function. Your scatter plot should ultimately 
appear like the image at the top of this section.

* Include state abbreviations in the circles.

* Create and situate your axes and labels to the left and bottom of the chart.

* Note: You'll need to use `python -m http.server` to run the visualization. This will 
host the page at `localhost:8000` in your web browser.
*/

// Step 1 - Process Data, use D3

// create container for values
payload = {
  'Healthcare': [],
  'Poverty': [],
  'State': [],
  'Abbreviation': []
}

d3.csv("assets/data/data.csv")
  .then(function(data) {
    console.log(data);

    // loop through data, extracting th healthcare and poverty values
    data.forEach(function(row) {
      payload['Poverty'].push(+row['poverty']);
      payload['Healthcare'].push(+row['healthcare']);
      payload['State'].push(row['state']);
      payload['Abbreviation'].push(row['abbr']);
    })

    console.log(`This is payload: ${payload}`);

    // Step 2 - Organize Data so that we can place into graphs

    console.log('Payload Poverty Values:');
    console.log(payload['Poverty']);

    // payload['Poverty'].forEach(function(value) {
    //   console.log(value);
    // })

    health_care = ['Healthcare'].concat(payload['Healthcare'])
    poverty_data = ['Poverty'].concat(payload['Poverty']);
    abbreviations = ['Abbreviations'].concat(payload['Abbreviation']);

    console.log('healthcare', health_care);
    console.log('poverty', poverty_data);
    console.log('abbreviations', abbreviations);

    // Step 3 - Make Scatter Chart
    var chart = c3.generate({
      bindto: '#scatter',
      data: {
          xs: {
              'Healthcare': 'Poverty'
          },
          // iris data from R
          columns: [
            poverty_data,
            health_care
          ],
          type: 'scatter'
      },
      axis: {
          x: {
              label: 'Poverty',
              tick: {
                  fit: false
              }
          },
          y: {
              label: 'Healthcare'
          }
      },
      point: {
        r: 5
      },
      tooltip: {
        format: {
          title: function (x, index) { 
            return `[${abbreviations[index + 1]}] Poverty Rate: ` + x; 
          }
        }
      }
    });

  })