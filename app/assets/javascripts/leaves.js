/* Needs to handle:
   - change of date
   - change of leave type
   - addition of more leave days
   - update hours
   - adding "breaks" (split existing bars or add additional on to end? If add, change other functionality to match?)
   - add leave values to form
   - partial leave days (how to do this?)
*/

$(function(){
  var self, leaves_controller = function(){
    $(document).on('change', '.leaves-form #leave_date', this.dateChanged);
    $(document).on('change', '.leaves-form #leave_type', this.typeChanged);
    $(document).on('change', '.leaves-form .slider-intervals, .leave-table.editable .slider-intervals', this.hoursChanged);
    $(document).on('click', '.leaves-form .add-day-btn', this.addDay);
    $(document).on('click', '.leaves-form .fa-minus-square, .leave-table.editable .fa-minus-square', this.removeBreak);
    $(document).on('click', '.leaves-form .fa-plus-square, .leave-table.editable .fa-plus-square', this.addBreak);
    $(document).on('click', '.leaves-form .multirange-slider-range, .leave-table.editable .multirange-slider-range', this.activateLeave);
    $(document).on('change', '.leave-table.editable .slider-intervals', this.editLeave);
    $(document).on('click', '.leave-table .fa-times', this.removeLeave);
    $(document).on('submit', '.leaves-form', this.addRanges);
  }

  leaves_controller.prototype.dateChanged = function(){
    // Change the days displayed on the "days off"
    var date = moment($(this).val());
    $('.leave-table tr').each(function(i){
      $(this).find('td:first-child').html(date.add('d', i === 0 ? 0 : 1).format('dddd'));
    })
  }
  
  leaves_controller.prototype.typeChanged = function(e){
    var from = $(this).data('original-value'),
        to = $(this).val();
    // rewrite the type of leave. Only overwrite the type that we changed from to the type that we're changing to.
    $('.slider-intervals').each(function(){
      var hours = $(this).multirange_slider('value');
      _.each(hours, function(h){ if(h[2] === from) h[2] = to; } );
      $(this).multirange_slider('setIntervals', hours);
    });
    $(this).data('original-value', to);
  }
  
  leaves_controller.prototype.hoursChanged = function(){
    // update the number of hours requested off for this day
    var hours = $(this).multirange_slider('value'),
        type = $('#leave_type').val() || _.first(_.compact(_.pluck(hours, 2))),
        sum = _.reduce(hours, function(memo, h){ return memo + (h[2] === type ? h[1] - h[0] : 0); }, 0);
    $(this).closest('tr').find('td:last-child').html(sum + ' hour' + (sum === 1 ? '' : 's'));
  }
  
  leaves_controller.prototype.addDay = function(){
    // Add a new slider on to the bottom
    var slider_row = $('.leave-table tr:first-child').clone(),
        slider = slider_row.find('.slider-intervals').multirange_slider(sumtimes.slider.DEFAULT_OPTIONS);
    $('.leave-table tbody').append(slider_row);
    self.dateChanged.call($('#leave_date'));
    
    // Go ahead and go out to get the hours that the employee was supposed to work here    
    self.hoursChanged.call(slider);
  }
  
  leaves_controller.prototype.removeBreak = function(){
    // 2 options:
    // - Standard: basic removal of break, pressing it when there is only one slider will remove that slider
    // - New: Removes the last slider
    $(this).closest('tr').find('.slider-intervals').multirange_slider('combineInterval');
  }
  
  leaves_controller.prototype.addBreak = function(){
    // see remove break except adding instead. 2nd option will add 4 hour (or max) slider. If there isn't enough room, make room.
    var type = $('#leave_type').val(),
        slider = $(this).closest('tr').find('.slider-intervals');
    if(!type){
      type = _.first(_.compact(_.pluck(slider.multirange_slider('value'), 2)));
    }
    slider.multirange_slider('splitInterval', 0, type);
  }
  
  leaves_controller.prototype.activateLeave = function(e){
    // Figure out which slider we clicked, toggle the leave status of that slider
    if(e.target != e.currentTarget){
      return;
    }
    var range = $(this),
        par = range.closest('.multirange-slider'),
        index = par.find('.multirange-slider-range').index(range),
        hours = par.multirange_slider('value'),
        type = $('#leave_type').val();
    
    if(!type){
      type = par.data('type');
      if(!type){
        type = _.first(_.compact(_.pluck(hours, 2)));
        par.data('type', type);
      }
    }
    
    if(!hours[index]){
      return;
    }
    
    if(hours[index][2] == type){
      delete hours[index][2];
    } else {
      hours[index][2] = type;
    }
    
    par.multirange_slider('setIntervals', hours);
  }
  
  leaves_controller.prototype.addRanges = function(){
    // Add the ranges that the user has selected to the form via hidden fields.
    $('.slider-intervals').each(function(){
      var hidden_field = $('<input type="hidden" name="leave[hours]' + ($('.edit-leaves').length > 0 ? '' : '[]' ) + '">'),
          selector_hours = $(this).multirange_slider('value');
      hidden_field.val( JSON.stringify( $.map( selector_hours, function(arr){ return {start: arr[0], end: arr[1], type: arr[2]}; }) ) );
      $(this).append(hidden_field);    
    });
  }
  
  leaves_controller.prototype.saveType = function(){
    $('.leaves-form #leave_type').data('original-value', $('.leaves-form #leave_type').val());
  }
  
  // Edit on-the-fly changes to upcoming leaves, send to server
  leaves_controller.prototype.editLeave = function(){
    var $this = $(this),
        hours = $this.multirange_slider('value'),
        id = $this.closest('tr').data('workday'),
        data = _.map(hours, function(arr){ return {start: arr[0], end: arr[1], type: arr[2]}; });
        
    $.ajax({
      type: 'PUT',
      contentType: "application/json; charset=utf-8",      
      url: '/leaves/' + id + '.json',
      data: JSON.stringify({leave: {hours: data}})
    });
  }
  
  // Send destroy message to server, hide leave row
  leaves_controller.prototype.removeLeave = function(){
    if(!confirm("Are you sure want to cancel this leave? This action cannot be undone.")){
      return;
    }
    
    var row = $(this).closest('tr'),
        id = row.data('workday');
    $.ajax({
      type: 'DELETE',
      url: '/leaves/' + id + '.json'
    });
    
    row.fadeOut();
  }
  
  self = new leaves_controller();
  $(document).on('page:change', self.saveType);
  _.defer(self.saveType);
});
