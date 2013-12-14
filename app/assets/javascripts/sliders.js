//= require multirange-slider

$(function(){
  var default_options = { 
    min: 0, 
    max: 24, 
    step: 0.25,
    displayFormat: function(val){
      var hours = Math.floor(val);
      return moment().hour(hours).minute(60*(val - hours)).format('h:mm A').replace(/ /, '&nbsp;');
    } 
  };
  
  if("undefined" === typeof(sumtimes)){ sumtimes = {} };
  sumtimes['slider'] = { DEFAULT_OPTIONS: default_options };
  
  var self, sliders_controller = function(){
    $('.slider-intervals').multirange_slider(default_options);
    $('.hour-slider').multirange_slider($.extend({}, default_options, {disabled: true, showTip: false}))
  }
  
  function init(){
    self = new sliders_controller();
  }
  
  _.defer(init);
  $(document).on('page:change', init);
});
