$(function(){
  var self, punch_controller = function(){
    $(document).on('click', '.punch .punch-btn', this.punch);
  }
  
  function convert_hours(hours){
    return _.map(hours, function(h){ return [h['start'], h['end'] || h['start'], h['type']]; })
  }
  
  punch_controller.prototype.punch = function(){
    var dir = $(this).data('direction');
    
    $.ajax({
      url: '/punch_' + dir + '.json',
      type: 'POST',
      contentType: "application/json; charset=utf-8",
      data: JSON.stringify({ date: moment().format('YYYY-MM-DD'), time: moment().hour() + moment().minute()/60 }),
      success: function(data){    
        var hours = convert_hours(data.hours)    
        $('.punch-btn').toggleClass('hide');
        $('.punch .hour-slider').multirange_slider('setIntervals', hours);
      }
    });
  }
  
  punch_controller.prototype.drawPunch = function(){
    // get today's workday
    $.get('/workdays/on_date/' + moment().format('YYYY-MM-DD') + '.json', function(data){
      var punched_in = data.hours.length > 0 && _.isUndefined(_.last(data.hours)['end']),
          hours = convert_hours(data.hours),
          in_btn = $('<div class="btn btn-success btn-block punch-btn">Punch In</div>').data('direction', 'in').addClass(punched_in ? 'hide' : ''),
          out_btn = $('<div class="btn btn-success btn-block punch-btn">Punch Out</div>').data('direction', 'out').addClass(punched_in ? '' : 'hide');
      
      // set the slider
      $('.punch .hour-slider').multirange_slider('setIntervals', hours);
      
      $('.punch').append(in_btn);
      $('.punch').append(out_btn);
    });
  }
  
  function init(){
    if($('.punch').length > 0){
      self.drawPunch();
    }
  }
  
  self = new punch_controller();
  _.defer(init);  
  $(document).on('page:change', init);
});
