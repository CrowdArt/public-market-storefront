window.pm = window.pm || {}

var formsWithLeaveCheck = '.leave-check'
$(document).on('change, input', 'input, textarea, select', formsWithLeaveCheck, function() {
  $(this).parents('form').addClass('form-dirty')
  $('body').attr('data-turbolinks', false)
}).on('submit', formsWithLeaveCheck, function() {
  $(this).removeClass('form-dirty')
  return true
})

$(window).on('beforeunload', function() {
  if ($('form.leave-check.form-dirty').length > 0)
    return 'You have unsaved changes, are you sure you want to discard them?'
})

$(document).on('keyup', '.form-group-invalid input, .form-group-invalid textarea', function() {
  $(this).parents('.form-group-invalid')
         .removeClass('form-group-invalid')
         .find('.invalid-feedback')
         .remove()
})

$(document).on('change', ".input-with-hint input", function() {
  var val = $(this).val()
  val ? $(this).attr('value', val) : $(this).removeAttr('value')
});
