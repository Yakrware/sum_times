$(function(){
  $(document).on('submit', '.employees .edit_user', function(){
    var day_start = $('<input type="hidden" name="user[option_attributes][value][day_start]">'),
        day_end = $('<input type="hidden" name="user[option_attributes][value][day_end]">'),
        interval = $('.slider-intervals').multirange_slider('value');
    day_start.val(interval[0][0]);
    day_end.val(interval[0][1]);
    $('.employees .edit_user').append(day_start).append(day_end);
  });
});
