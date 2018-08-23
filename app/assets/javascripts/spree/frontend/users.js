$(document).on('input', '.user-edit-form #user_email', function() {
  $('.user_email--addition-wrapper').toggle($(this).val() == $(this).data('old-email'))
})

$(document).on('ajax:beforeSend', '#edit_user_info', function() {
  var emailInput = $('.user-edit-form #user_email')

  if ($('#reconfirm-email-modal').length > 0 && emailInput.val() !== emailInput.data('old-email')) {
    $('#reconfirm-email-modal').modal('show')
    return false
  }
})

$(document).on('click', '#reconfirm-email-btn', function() {
  $('#reconfirm-email-modal').on('hidden.bs.modal', function() {
    $('#reconfirm-email-modal').remove()
    $('#edit_user_info').submit()
  })
})
