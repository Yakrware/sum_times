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
    if(_.isEmpty(si.multirange_slider('value')) ){
      si.multirange_slider('setIntervals', [[si.data('slider-min'), si.data('slider-max')]] );
    }
    
    // send a create (post) message to the server
  }
  
  schedule_controller.prototype.deactivateUser = function(e){
    var parent = $(this).closest('tr');
    parent.addClass('disabled');  
    var si = parent.find('.slider-intervals');
    si.multirange_slider('disable');
    
    // send a destroy (delete) message to the server
  }
  
  
  schedule_controller.prototype.removeBreak = function(){
    $(this).closest('tr').find('.slider-intervals').multirange_slider('combineInterval');
  }
  
  schedule_controller.prototype.addBreak = function(){
    $(this).closest('tr').find('.slider-intervals').multirange_slider('splitInterval');
  }
  
  schedule_controller.prototype.hoursChanged = function(e, data){
    1==1;
    // send an update (put) message to the server
  }
  
  self = new schedule_controller();
});
