function buildMetadata(sample) {

  // @TODO: Complete the following function that builds the metadata panel

  // Use `d3.json` to fetch the metadata for a sample
  d3.json(`/metadata/${sample}`).then(function(response){
    
    console.log(response);
  
    // Use d3 to select the panel with id of `#sample-metadata`
    var panel = d3.select("#sample-metadata");

    // Use `.html("") to clear any existing metadata
    panel.html("");

    // Use `Object.entries` to add each key and value pair to the panel
    // Hint: Inside the loop, you will need to use d3 to append new
    // tags for each key-value in the metadata.

    Object.entries(response).forEach(([key,value])=>{
      panel.append('p').text(`${key} : ${value}`);

    });

  });

};

function buildCharts(sample) {

  // @TODO: Use `d3.json` to fetch the sample data for the plots
  d3.json(`/samples/${sample}`).then(function(response){

    // @TODO: Build a Bubble Chart using the sample data
    var bubble = d3.select("bubble");

    var trace1 = {

      x: response.otu_ids,
      y: response.sample_values,
      text: response.otu_labels,
      mode: 'markers',
      marker: {

        color: response.otu_ids,
        size: response.sample_values

      },

      colorscale: 'Picnic'

    };

    var data = [trace1];

    var layout = {

      title: 'Bacterial Biodiversity of Sample (by Count)',
      xaxis: {title: 'Bacteria ID'},
      yaxis: {title: 'Total Viable Count (TVC)'},
      showlegend: false,
      height: 750,
      width: 1200,

    };

    Plotly.newPlot('bubble', data, layout);

    // @TODO: Build a Pie Chart
    // HINT: You will need to use slice() to grab the top 10 sample_values,
    // otu_ids, and labels (10 each).

    var pie = d3.select("pie");

    var trace2 = [{

      values: response.sample_values.slice(0,10),
      labels: response.otu_ids.slice(0,10),
      hovertext: response.otu_labels.slice(0,10),
      hole: .4,
      type: 'pie'

    }];

    var layout2 = {

      title: 'Bacterial Biodiversity of Sample (by Proportion)'

    };

    Plotly.newPlot('pie',trace2,layout2);

  });
  
};

function init() {
  // Grab a reference to the dropdown select element
  var selector = d3.select("#selDataset");

  // Use the list of sample names to populate the select options
  d3.json("/names").then((sampleNames) => {

    sampleNames.forEach((sample) => {

      selector
        .append("option")
        .text(sample)
        .property("value", sample);

    });

    // Use the first sample from the list to build the initial plots
    const firstSample = sampleNames[0];
    buildCharts(firstSample);
    buildMetadata(firstSample);

  });

};

function optionChanged(newSample) {
  // Fetch new data each time a new sample is selected
  buildCharts(newSample);
  buildMetadata(newSample);

};

// Initialize the dashboard
init();