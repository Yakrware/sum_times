// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require underscore
//= require bootstrap
//= require bootstrap-timepicker
//= require bootstrap-datepicker/core
//= require moment
//= require turbolinks
//= require flowtype
//= require_tree .

$(function(){
  $('a[href$="' + window.location.pathname + '"]').closest('li').addClass('active')
  
  function init(){
    $('body').scrollspy('refresh')
    initTooltips();
    initDatePickers();
    initFlow();
  }
  
  function initTooltips(){
    $('[data-toggle=tooltip]').tooltip();
  }
  
  function initDatePickers(){
    $(document).on("focus", "[data-behavior='datepicker']", function(e){
        $(this).datepicker({"format": "yyyy-mm-dd", "weekStart": 0, "autoclose": true});
    });
  }
  
  function initFlow(){
    $('.flow-large').flowtype({
      fontRatio: 30,
      minimum: 800,
      maximum: 1200
    })
    $('.flow-normal').flowtype({
      fontRatio: 40,
      minimum: 800,
      maximum: 1200
    });
    $('.flow-small').flowtype({
      fontRatio: 60,
      minimum: 1000,
      maximum: 1200
    });
  }
  
  function scrollToID(id, speed){
	  var targetOffset = $(id).offset().top;
	  $('html,body').animate({scrollTop:targetOffset}, speed);
  }
  
  $(document).on('click', '.scroll-link', function(event){
    if(this.pathname === window.location.pathname){
		  event.preventDefault();
		  var sectionID = this.hash;
		  scrollToID(sectionID, 750);      
    }
	});
	
	// scroll to top action
	$(document).on('click', '.scroll-top', function(event) {
		event.preventDefault();
		$('html,body').animate({scrollTop:0}, 'slow'); 		
	});
  
  _.defer(init);
  $(document).on('page:change', init);
});
