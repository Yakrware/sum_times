//= require multirange-slider

$(function(){
  var self, sliders_controller = function(){
    $('.slider-intervals').multirange_slider({ 
      min: 0, 
      max: 24, 
      step: 0.25,
      displayFormat: function(val){
        var hours = Math.floor(val);
        return moment().hour(hours).minute(60*(val - hours)).format('h:mm A');
      } 
    });
  }
  
  function init(){
    self = new sliders_controller();
  }
  
  window.setTimeout(init, 1);
  $(document).on('page:change', init);
});
