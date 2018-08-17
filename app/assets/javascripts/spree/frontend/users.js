$(document).one('keyup', '.user-edit-form #user_email', function() {
  $('.user_email--verify-wrapper').remove()
  $(this).parents('.form-group').find('.feedback-hint').remove()
})
