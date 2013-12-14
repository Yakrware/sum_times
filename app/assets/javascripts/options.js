$(function(){
  var self, option_controller = function(){
    $(document).on('change', '.option-form .leave-types input[type=checkbox]', this.leaveTypeChanged);
  }
  
  option_controller.prototype.leaveTypeChanged = function(){
    var checked = this.checked,
        name = $(this).val();
        
    if(checked){
      // add a row
      var accrual_html = ['<div class="clearfix leave-accrual">',
                    '<div class="col-sm-3"><label for="company_option_attributes_company[option_attributes][value][leave_accrual][' + name + ']">' + name + '</label></div>',
                    '<div class="col-sm-9"><input class="form-control" id="company_option_attributes_value_leave_accrual_' + name + '" min="0" name="company[option_attributes][value][leave_accrual][' + name + ']" step="any" type="number" value="0"></div>',
                  '</div>'].join(''),
          initial_html = accrual_html.replace(/accrual/g, 'initial');
      $('.leave-accruals').append(accrual_html);
      $('.leave-initials').append(initial_html);
    } else {
      // remove the row
      $('#company_option_attributes_value_leave_accrual_' + name).closest('div.leave-accrual').remove();
      $('#company_option_attributes_value_leave_initial_' + name).closest('div.leave-initial').remove();
    }
  }
  
  self = new option_controller();
});
