$(function(){"use strict";Morris.Area({element:"morris-area-chart2",data:[{period:"2010",iMac:0,iPhone:0},{period:"2011",iMac:130,iPhone:100},{period:"2012",iMac:30,iPhone:60},{period:"2013",iMac:30,iPhone:200},{period:"2014",iMac:200,iPhone:150},{period:"2015",iMac:105,iPhone:90},{period:"2016",iMac:250,iPhone:150}],xkey:"period",ykeys:["iMac","iPhone"],labels:["iMac","iPhone"],pointSize:0,fillOpacity:.7,pointStrokeColors:["#b4becb","#727cf5"],behaveLikeLine:!0,gridLineColor:"#e0e0e0",lineWidth:0,smooth:!0,hideHover:"auto",lineColors:["#b4becb","#727cf5"],resize:!0}),Morris.Donut({element:"morris-donut-chart",data:[{label:"Orders",value:8500},{label:"Panding",value:3630},{label:"Delivered",value:4870}],resize:!0,colors:["#0acf97","#727cf5","#4F5467"]})});