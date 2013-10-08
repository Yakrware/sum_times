$(function(){
  var self, workday_controller = function(){
    $(document).on('submit', '.workday-form', this.addRange);
  }
  
  workday_controller.prototype.addRange = function(e){
    var hidden_field = $('<input type="hidden" name="workday[hours]">'),
        selector_hours = $('.slider-intervals').multirange_slider('value');
    hidden_field.val( JSON.stringify( $.map( selector_hours, function(arr){ return {start: arr[0], end: arr[1]}; }) ) );
    $(this).append(hidden_field);
  }
  
  function init(){
    self = new workday_controller();
  }
  
  setTimeout(init, 1);
  $(document).on('page:change', init);
});
