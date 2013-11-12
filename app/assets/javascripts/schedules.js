// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function(){
  var self, schedule_controller = function(){
    $(document).on('click', '.scheduling-table .activate-user', this.activateUser);
    $(document).on('click', '.scheduling-table .deactivate-user', this.deactivateUser);
    $(document).on('change', '.scheduling-table .slider-intervals', this.hoursChanged);
    $(document).on('click', '.scheduling-table .remove-break', this.removeBreak);
    $(document).on('click', '.scheduling-table .add-break', this.addBreak);
  }
  
  schedule_controller.prototype.activateUser = function(){
    var parent = $(this).closest('tr');
    parent.removeClass('disabled');
    
    var si = parent.find('.slider-intervals');
    si.multirange_slider('enable');
    
    // send a create (post) message to the server
    $.post('/schedules.json', {user_id: parent.data('user-id'), hours: si.multirange_slider('value'), date: parent.data('date')}, function(data){
      // set workday id, set workday edit link, set recurring indication
      parent.data('workday-id', data.id);
      si.multirange_slider('setIntervals', _.map(data.hours, function(h){ return [h["start"], h["end"], h["type"]]; }) );
      var last_td = parent.find('td:last-child');
      if(!_.isEmpty(data.recurring_days)){
        last_td.append('<i class="fa fa-refresh" title="Recurring"></i>');
      }
      if(_.isEmpty(last_td.find('.edit-workday'))){
        last_td.append('<a href="/schedules/' + data.id + '/edit" class="edit-workday"><i class="fa fa-edit"></i></a>');
      }
    }, 'json');
  }
  
  schedule_controller.prototype.deactivateUser = function(e){
    var parent = $(this).closest('tr'),
        si = parent.find('.slider-intervals');
    parent.addClass('disabled');  
    si.multirange_slider('disable');
    
    parent.find('.edit-workday').remove();
    parent.find('.fa-refresh').remove();
    
    // send a destroy (delete) message to the server
    $.ajax({
      type: 'DELETE',
      url: '/schedules/' + parent.data('workday-id') + '.json',
      data: {date: parent.data('date')},
      success: function(){},
      dataType: 'json'
    });
    
    parent.data('workday-id', '');
  }  
  
  schedule_controller.prototype.removeBreak = function(){
    $(this).closest('tr').find('.slider-intervals').multirange_slider('combineInterval');
  }
  
  schedule_controller.prototype.addBreak = function(){
    $(this).closest('tr').find('.slider-intervals').multirange_slider('splitInterval');
  }
  
  schedule_controller.prototype.hoursChanged = function(e, data){
    var parent = $(this).closest('tr');
    _.each(data, function(a){ a[2] = 'scheduled'; });    
    
    // send an update (put) message to the server
    $.ajax({
      type: 'PUT',
      url: '/schedules/' + parent.data('workday-id') + '.json',
      data: {hours: data, date: parent.data('date')},
      success: function(data){
        parent.data('workday-id', data.id); 
        var si = parent.find('.slider-intervals');
        si.multirange_slider('setIntervals', _.map(data.hours, function(h){ return [h["start"], h["end"], h["type"]]; }) );
        if(!_.isEmpty(data.recurring_days)){
          last_td.append('<i class="fa fa-refresh" title="Recurring"></i>');
        }
        else {
          parent.find('.fa-refresh').remove();
        }
      },
      dataType: 'json'
    });
  }
  
  self = new schedule_controller();
});
