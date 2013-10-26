$(function(){
  var self, workday_controller = function(){
    $(document).on('submit', '.workday-form', this.addRange);
    $(document).on('click', '.workday-form .remove-break', this.removeBreak);
    $(document).on('click', '.workday-form .add-break', this.addBreak);
  }
  
  workday_controller.prototype.addRange = function(e){
    var hidden_field = $('<input type="hidden" name="workday[hours]">'),
        selector_hours = $('.slider-intervals').multirange_slider('value');
    hidden_field.val( JSON.stringify( $.map( selector_hours, function(arr){ return {start: arr[0], end: arr[1]}; }) ) );
    $(this).append(hidden_field);
  }
  
  workday_controller.prototype.removeBreak = function(){
    $('.slider-intervals').multirange_slider('combineInterval');
  }
  
  workday_controller.prototype.addBreak = function(){
    $('.slider-intervals').multirange_slider('splitInterval');
  }
  
  self = new workday_controller();
});
