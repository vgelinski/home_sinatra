var startDateTextBox = $('#from');
var endDateTextBox = $('#to');

var startDateBackup = "";
var endDateBackup = "";

function inspect(obj){
  var ret = "";
  for(var key in obj){
    ret += (key + ":  " + obj[key] + "\n\n");
  }
  return ret;
}


function dateFromString(str) {
  var m = str.match(/(\d+).(\d+).(\d+) (\d+)\:(\d+)/);
  return new Date(+m[3], +m[2] - 1, +m[1], +m[4], +m[5], 0, 0);
}

function attachDateTimePickers(){
  $('#from').datetimepicker({
    onClose: function(dateText, inst) {
      if (endDateTextBox.val() != '') {
        var testStartDate = startDateTextBox.datetimepicker('getDate');
        var testEndDate = endDateTextBox.datetimepicker('getDate');
        var startDateStr = document.getElementById("from").value;
        var endDateStr = document.getElementById("to").value;
        var startDateParsed = dateFromString(startDateStr);
        var endDateParsed = dateFromString(endDateStr);
        if (startDateParsed > endDateParsed){
          document.getElementById("from").value = startDateBackup
          startDateBackup = "";
          alert("Невалиден период");
        }else {
           endDateTextBox.val(dateText);
           startDateBackup = document.getElementById("from").value;
        }
      } 
    },
    dateFormat: "dd.mm.yy"
  });
   $('#to').datetimepicker({ 
    onClose: function(dateText, inst) {
      if (startDateTextBox.val() != '') {
        var testStartDate = startDateTextBox.datetimepicker('getDate');
        var testEndDate = endDateTextBox.datetimepicker('getDate');
        var startDateStr = document.getElementById("from").value;
        var endDateStr = document.getElementById("to").value;
        var startDateParsed = dateFromString(startDateStr);
        var endDateParsed = dateFromString(endDateStr);
        if (startDateParsed > endDateParsed){
          document.getElementById("to").value = endDateBackup
          endDateBackup = "";
          alert("Невалиден период");
        }else {
          startDateTextBox.val(dateText);
          endDateBackup = document.getElementById("to").value;
        }
      }
    },
    dateFormat: "dd.mm.yy"
  });

  $('#day_start').timepicker({
    timeFormat: "HH:mm"
  });

  $('#day_end').timepicker({
    timeFormat: "HH:mm"
  });

  $('#alarm_time').timepicker({
    timeFormat: "HH:mm"
  });
}

var dirty_inputs = [];

function addOnClick(){
  $("input").change(function(){
    dirty_inputs.push($(this));
  });
}

function clear(){
  dirty_inputs = [];
}

function onLoad(){
  clear();
  attachDateTimePickers();
  addOnClick();
}

function getStatisticsAjax(){
  var ajaxRequest;  // The variable that makes Ajax possible!

  try{
    // Opera 8.0+, Firefox, Safari
    ajaxRequest = new XMLHttpRequest();
  } catch (e){
    // Internet Explorer Browsers
    try{
      ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
      try{
        ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
      } catch (e){
        // Something went wrong
        alert("Your browser broke!");
        return false;
      }
    }
  }

  ajaxRequest.onreadystatechange = function(){
    if(ajaxRequest.readyState == 4){
      showStatistics(ajaxRequest.responseText)
    }
  }

  ajaxRequest.open("POST", "/get_statistics", true);
  ajaxRequest.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  var fromStr = document.getElementById("from").value;
  var toStr = document.getElementById("to").value;
  var interval = document.getElementById("interval").value;
  ajaxRequest.send("since=" + (dateFromString(fromStr).getTime()/1000) + "&to=" + (dateFromString(toStr).getTime()/1000) + "&interval=" + interval); 
}

function showStatistics(rawData){
  var json =JSON.parse(rawData);
  //alert(rawData);
  tz = -(new Date().getTimezoneOffset()) * 60;
  var temperatureData = [];
  var dailyConsumptionData = [];
  var nightConsumptionData = [];
  var dailyCostData = [];
  var nightCostData = [];
  var dailyConsumption = 0;
  var nightConsumption = 0;
  var dailyCost = 0;
  var nightCost = 0;
  var first = -1;
  var last = -1;

  for(var key in json){
    var d = new Date();
    var k = parseInt(key)
    d.setTime((k + tz) * 1000);
    temperatureData.push({
      x: d,
      y: json[key][2],
      from: json[key][0] + tz,
      to: json[key][1] + tz,

      unit: '°C'
    });
    dailyConsumptionData.push({
      x: d,
      y: json[key][3],
      from: json[key][0] + tz,
      to: json[key][1] + tz,
      unit: 'KWh'
    });
    nightConsumptionData.push({
      x: d,
      y: json[key][4],
      from: json[key][0] + tz,
      to: json[key][1] + tz,
      unit: 'KWh'
    });
    dailyCostData.push({
      x: d,
      y: json[key][5],
      from: json[key][0] + tz,
      to: json[key][1] + tz,
      unit: 'BGN'
    });
    nightCostData.push({
      x: d,
      y: json[key][6],
      from: json[key][0] + tz,
      to: json[key][1] + tz,
      unit: 'BGN'
    });
    dailyConsumption += json[key][3];
    nightConsumption += json[key][4];
    dailyCost += json[key][5];
    nightCost += json[key][6];
    first = (first === -1 || first > json[key][0]) ? json[key][0] : first;
    last = (last === -1 || last < json[key][1]) ? json[key][1] : last;
  }

  var totalConsumption = dailyConsumption + nightConsumption;
  var totalCost = dailyCost + nightCost;

  first = new Date((first + tz) * 1000);
  last = new Date((last + tz) * 1000);

  var chart = new Highcharts.Chart({
    chart: {
      renderTo: 'statistics_div',
      type: 'spline',
      zoomType: 'xy'
    },
    title: {
      text: 'Статистика за периода ' + Highcharts.dateFormat('%e.%b.%Y %H:%M', first) + " - " + Highcharts.dateFormat('%e.%b.%Y %H:%M', last)
    },
    subtitle: {
      text: 'Подробна информация за средната температура, изразходваната електоенергия и цената ѝ в левове <br/> за периода от ' + Highcharts.dateFormat('%e.%b.%Y %H:%M', first) + " до " + Highcharts.dateFormat('%e.%b.%Y %H:%M', last)
    },
    xAxis: {
      type: 'datetime',
      dateTimeLabelFormats: { // don't display the dummy year
        month: '%e. %b',
        year: '%b'
      }
    },
    yAxis: [{
      title: {
        text: 'Средна температура (°C)'
      },
      min: -20,
      max: 35
    },{
      gridLineWidth: 0,
      title: {
        text: 'Консумирана ел. енергия (KWh)'
      },
      min: 0
    },{
      gridLineWidth: 0,
      title: {
        text: 'Цена за отопление (BGN)'
      },
      min: 0,
      opposite: true
    }],

    tooltip: {
      formatter: function() {
                   if(this.series.type !== 'pie'){
                     var index = findIndexInArray(this.series.data, "x", this.x);
                     var from = new Date();
	             var to = new Date();
                     from.setTime(this.series.data[index]["from"]*1000);
                     to.setTime(this.series.data[index]["to"]*1000);
                     var total = this.series.type === 'column' ? "<br/><b>Общо</b> " + this.point.stackTotal.toFixed(2) +
                                 ' ' + this.series.data[index]["unit"] : "";
                     return '<b>'+ this.series.name +'</b> за периода<br/><b>От</b>' + Highcharts.dateFormat('%e.%b.%Y %H:%M', from) +
                             ' <b>До</b> ' + Highcharts.dateFormat('%e.%b.%Y %H:%M', to) + '<br/>' + this.y.toFixed( this.series.type === 'column' ? 2 : 1) +
                             ' ' + this.series.data[index]["unit"] + total;
                  }else{
                    return '<b>'+ this.point.name+'</b> за периода<br/><b>От</b>' + Highcharts.dateFormat('%e.%b.%Y %H:%M', first) +
                             ' <b>До</b> ' + Highcharts.dateFormat('%e.%b.%Y %H:%M', last) + '<br/>' + this.y.toFixed(2) + ' ' + this.series.options.unit + "<br/><b>Общо</b> " + this.series.options.totalValue.toFixed(2) + " " + this.series.options.unit;
                  }
                }
    },


    plotOptions: {
      column: {
        stacking: 'normal'
      },
      pie: {
        allowPointSelect: false,
        cursor: 'pointer',
        dataLabels: {
          enabled: false
        }
      }
    },
    

    series: [{
      name: 'Дневно потребление',
      type: 'column',
      color: '#80699B',
      data: dailyConsumptionData,
      stack: 'energy',
      yAxis: 1
    },{
      name: 'Нощно потребление',
      type: 'column',
      color: '#3D96AE',
      data: nightConsumptionData,
      stack: 'energy',
      yAxis: 1
    },{
      name: 'Цена на дневна енергия',
      type: 'column',
      color: '#89A54E',
      data: dailyCostData,
      stack: 'cost',
      yAxis: 2
    },{
      name: 'Цена на нощна енергия',
      type: 'column',
      color: '#AA4643',
      data: nightCostData,
      stack: 'cost',
      yAxis: 2
    },{
      name: 'Температура',
      data: temperatureData
    },{
      type: 'pie',
      size: '15%',
      center: [30, -20],
      unit: 'Kwh',
      totalValue: totalConsumption,
      data: [{
        name: 'Дневно потребление',
        y: dailyConsumption,
        color: '#80699B'
      },{
        name: 'Нощно потребление',
        y: nightConsumption,
        color: '#3D96AE'
      }]
    },{
      type: 'pie',
      size: '25%',
      innerSize: '15%',
      center: [30, -20],
      unit: "BGN",
      totalValue: totalCost,
      data: [{
        name: 'Цена за дневна енергия',
        color: '#89A54E',
        y: dailyCost
      },{
        name: 'Цена за нощна енергия',
        color: '#AA4643',
        y: nightCost}
      ]
    }]
  });
}

function findIndexInArray(array, key, target){
  var i;
  for(i = 0; i < array.length; i++){
    if(array[i][key] == target){
      return i;
    }
  }
  return -1;
}

function submitSettings(){
  var in_progress = noty({
    id: "in_progress",
    text: "Моля изчакайте",
    layout: "bottomLeft",
    type: "information",
    closeWith:[]
  });


  var data = {};
  for(var key in dirty_inputs){
    element = dirty_inputs[key];
    data[element.attr("id")] = element.val();
  }

  var complete = function(jqXHR, statusCode){
    removeNoty("in_progress");
    var fields = {
      day_start: "Начало на отчитане на дневна ел. енергия",
      day_end: "Начало на отчитaне на нощна ел. енергия",
      day_cost: "Дневна тарифа на ел. енергия",
      night_cost: "Нощна тарифа на ел. енергия",
      heater_power: "Мощност на отоплителния уред"
    };
    var json = JSON.parse(jqXHR["responseText"]);
    var succ = []
    var fail = []
    for(var key in json){
      if(json[key] === "succ"){
        succ.push(key);
      }else{
        fail.push(key);
      }
    }
    if(succ.length >= 1){
      var text = "";
      if(succ.length === Object.keys(dirty_inputs).length){
        text = "Всички полета са запазени";
      }else{
        text = "Следните полета са запазени: | ";
        for(var key in succ){
          text += fields[succ[key]] + " | ";
        }
      }
      for(var key in succ){
        $('#' +  succ[key]).attr("class", "success");
      }
      var s = noty({
        layout: 'bottomLeft',
        type: 'success',
        text: text,
        timeout: 5000
      });
    }
    if(fail.length >=1){
      var text = "Следните промени не бяха запазени: | "
      for(var key in fail){
        text+= fields[fail[key]];
        $('#' +  fail[key]).attr("class", "error");
       }
      var f = noty({
        layout: 'bottomLeft',
        type: 'error',
        text: text,
        timeout: 5000
      });
    }
  };
  $.ajax("/set_settings", {
    type: "POST",
    complete: complete,
    data: data
  });
}

function logout(){
  $.ajax({
    type: 'GET',
    url: '/',
    dataType: 'json',
    async: false,
    username: "logout",
    password: "",
    data: ""
  });
}

function removeNoty(id){
  note = document.getElementById(id);
  note.parentNode.parentNode.removeChild(note.parentNode);
}


function submitNotifications(){ 
  var in_progress = noty({
    id: "in_progress",
    text: "Моля изчакайте",
    layout: "bottomLeft",
    type: "information",
    closeWith:[]
  });
  var temperature_notify_enabled = $('#temperature_notify_enabled').is(":checked");
  var temperature_notify_min_int = $('#temperature_notify_minimal_interval').val();
  var notify_emails = $('#notify_emails').val();
  var min_temp = $('#minimal_temperature_to_notify').val();
  //var night_cost = $('#night_cost').val();

  var data = { 
    temperature_notify_enabled:temperature_notify_enabled,
    temperature_notify_minimal_interval:temperature_notify_min_int,
    minimal_temperature_to_notify:min_temp,
    notify_emails:notify_emails
  }

  var complete = function(jqXHR, status_code){
    removeNoty("in_progress");
    var fields = {
      temperature_notify_minimal_interval: "Минимален интервал на известяване за температурата",
      minimal_temperature_to_notify: "Минималнатемпература за известяване"
    };
    var json = JSON.parse(jqXHR["responseText"]);
    var succ = []
    var fail = []
    for(var key in json){
      if(json[key] === "succ"){
        succ.push(key);
      }else if(json[key] === "fail"){
        fail.push(key);
      }
    }
    if(succ.length >= 1){
      var text = "";
      if(fail.length === 0){
        text = "Всички полета са запазени";
      }else{
        text = "Следните полета са запазени: | ";
        for(var key in succ){
          text += fields[succ[key]] + " | ";
        }
      }
      for(var key in succ){
        if(succ[key].indexOf("@") === -1){
          $('#' +  succ[key]).attr("class", "success");
        }else{
        }
      }
      var s = noty({
        layout: 'bottomLeft',
        type: 'success',
        text: text,
        timeout: 5000
      });
    }
    if(fail.length >=1){
      var text = "Следните промени не бяха запазени: | "
      for(var key in fail){
        text+= fields[fail[key]] == null ? fail[key] : fields[fail[key]];
        text+= " | "
        if(fail[key].indexOf("@") === -1){
          $('#' +  fail[key]).attr("class", "error");
        }else{
        }
      }
      var f = noty({
        layout: 'bottomLeft',
        type: 'error',
        text: text,
        timeout: 5000
      });
    }

  }

  $.ajax("/set_notifications", {
    type: "POST",
    complete: complete,
    data: data
  });
}

function falseAlarm(){
  var success = function(jqXHR, status_code){
    var s = noty({
      layout: 'bottomLeft',
      type: 'success',
      text: "Известията са изпратени успешно",
      timeout: 5000
    });
  }

  var error = function(jqXHR, status_code){
    
      var e = noty({
        layout: 'bottomLeft',
        type: 'error',
        text: "Грешка при изпращане на известията",
        timeout: 5000
      });
  }

  $.ajax("/false_alarm", {
    type: "POST",
    success:success,
    error: error,
    data: ""
  });
}


function changeLampState(){

  var state = $("#lamp_img").attr("src") === "/images/lamp_on.png" ? "off" : "on";

  var data = {
    state: state
  }

  var complete = function(jqXHR, status_code){
    var json = JSON.parse(jqXHR["responseText"]);
    var src = json["lamp_status"] === "on" ? "/images/lamp_on.png" : "/images/lamp_off.png"
    $("#lamp_img").attr("src", src);
  }

  $.ajax("/change_lamp_state", {
    type: "POST",
    complete:complete,
    data: data
  });
}

function setAlarm(){
  var data = {
    alarm_time: $('#alarm_time').val()
  };

  var complete = function(jqXHR, status_code){
    var json = JSON.parse(jqXHR["responseText"]);
    if(json["alarm"] === "on"){
      var s = noty({
        layout: 'bottomLeft',
        type: 'success',
        text: "Алармата е зададена",
        timeout: 5000
      });
    }
  }

  $.ajax("/set_alarm", {
    type: "POST",
    complete:complete,
    data: data
  });
}

function cancelAlarm(){

  var data = {
  }

  var complete = function(jqXHR, status_code){
    var json = JSON.parse(jqXHR["responseText"]);
    if(json["alarm"] === "off"){
      $('#alarm_time').val('');
      var f = noty({
        layout: 'bottomLeft',
        type: 'error',
        text: "Алармата е отменена",
        timeout: 5000
      });
    }

  }

  $.ajax("/set_alarm", {
    type: "POST",
    complete:complete,
    data: data
  });
}

