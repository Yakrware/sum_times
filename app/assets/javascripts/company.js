// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function(){
  $(document).on('submit', '.edit_company', function(){
    var day_start = $('<input type="hidden" name="company[option_attributes][value][day_start]">'),
        day_end = $('<input type="hidden" name="company[option_attributes][value][day_end]">'),
        interval = $('.slider-intervals').multirange_slider('value');
    day_start.val(interval[0][0]);
    day_end.val(interval[0][1]);
    $('.edit_company').append(day_start).append(day_end);
  });
});
