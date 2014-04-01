var DashboardIndex = {
  run: function() {
    if ($("#dashboard").length) {
      DashboardIndex.setup();
    }
  },
  setup: function() {
    DashboardIndex.initChart();
    
    $('.chart-control .resource button').click(function(event) {
      $(this).parent().find('.active').removeClass('active');
      $(this).addClass('active');
      
      var resource = $(this).data('resource');
      
      if (resource == 'sales') {
        DashboardIndex.chartSales();
      }
      if (resource == 'purchases') {
        DashboardIndex.chartPurchases();
      }
    });
    
    $('.chart-control .period button').click(function(event) {
      $(this).parent().find('.active').removeClass('active');
      $(this).addClass('active');
      
      $('.chart-container').hide();
      $('.chart-spinner').show();
      
      var resource_active = $('.chart-control .resource button.active').data('resource');
      var period = $(this).data('period');
      
      $('.chart-control .resource button').each(function() {
        var resource = $(this).data('resource');
        $.getJSON($('.chart-container').data(resource + '-url') + '/?period=' + period, function(data) {
          $('.chart-container').data(resource, data[resource]);
          
          if (resource == resource_active) {
            $('.chart-spinner').hide();
            $('.chart-container').show();
            if (resource_active == 'sales') {
              DashboardIndex.chartSales();
            } else {
              DashboardIndex.chartPurchases();
            }
          }
        });
      });
      
      event.stopPropagation();
    });
  },
  initChart: function() {
    $('.chart-spinner').hide();
    $('.chart-container').show();
    DashboardIndex.chartSales();
    
    var previousPoint = null;
    $(".chart-container").bind("plothover", function (event, pos, item) {
      if (item) {
        if (previousPoint != item.dataIndex) {
          previousPoint = item.dataIndex;
          
          $("#tooltip").remove();
          
          var label = item.series.xaxis.ticks[item.dataIndex].label;
          
          if (item.series.label == 'Total' || item.series.label == 'Cash' || item.series.label == 'Credit') {
            var x = item.datapoint[0].toFixed(2);
            var y = item.datapoint[1].toFixed(2);
            DashboardIndex.showTooltip(item.pageX, item.pageY, item.series.label + " of " + label + ": $" + y);
          } else {
            var x = item.datapoint[0].toFixed(0);
            var y = item.datapoint[1].toFixed(0);
            DashboardIndex.showTooltip(item.pageX, item.pageY, item.series.label + " of " + label + ": " + y);
          }
        }
      } else {
        $("#tooltip").remove();
        previousPoint = null;
      }
    });
  },
  chartSales: function() {
    var data = $('.chart-container').data('sales');
    
    var total = [];
    var quantity = [];
    var ticks = [];
    var now = new Date();
    $.each(data, function(index, point) {
      var date = new Date(now.getTime() + (24*60*60*1000 * point.day));
      total.push([index, parseFloat(point.total / 100)]);
      quantity.push([index, point.quantity]);
      ticks.push([index, $.datepicker.formatDate('mm-dd', date)]);
    });
    var _data = [{ data: total, label: "Total"},{ data: quantity, label: "Quantity" }];
    
    DashboardIndex.chart(_data, ticks);
  },
  chartPurchases: function() {
    var data = $('.chart-container').data('purchases');
    
    var cash = [];
    var credit = [];
    var quantity = [];
    var ticks = [];
    var now = new Date();
    $.each(data, function(index, point) {
      var date = new Date(now.getTime() + (24*60*60*1000 * point.day));
      cash.push([index, parseFloat(point.cash / 100)]);
      credit.push([index, parseFloat(point.credit / 100)]);
      quantity.push([index, point.quantity]);
      ticks.push([index, $.datepicker.formatDate('mm-dd', date)]);
    });
    var _data = [{ data: cash, label: "Cash"},{ data: credit, label: "Credit"},{ data: quantity, label: "Quantity" }];
    
    DashboardIndex.chart(_data, ticks);
  },
  chart: function(data, ticks) {
    var plot = $.plot($(".chart-container"), data, {
      series: {
        lines: { 
          show: true,
          lineWidth: 1,
          fill: true,
          fillColor: { colors: [ { opacity: 0.1 }, { opacity: 0.13 } ] }
        },
        points: { 
          show: true,
          lineWidth: 2,
            radius: 3
          },
        shadowSize: 0
      },
      grid: { 
        hoverable: true,
        clickable: true,
        tickColor: "#f9f9f9",
        borderWidth: 0
      },
      legend: {
        labelBoxBorderColor: "#fff"
      },  
      colors: ["#a7b5c5", "#30a0eb"],
      xaxis: {
        ticks: ticks,
        font: {
          size: 12,
          family: "Open Sans, Arial",
          variant: "small-caps",
          color: "transparent"
        }
      },
      yaxis: {
        ticks: 4, 
        tickDecimals: 0,
        font: {size: 12, color: "#9da3a9"}
      }
    });
  },
  showTooltip: function(x, y, contents) {
    $('<div id="tooltip">' + contents + '</div>').css( {
      position: 'absolute',
      display: 'none',
      top: y - 30,
      left: x - 50,
      color: "#fff",
      padding: '2px 5px',
      'border-radius': '6px',
      'background-color': '#000',
      opacity: 0.80
    }).appendTo("body").fadeIn(200);
  }
};

$(function() { DashboardIndex.run(); });