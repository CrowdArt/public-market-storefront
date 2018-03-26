function initFormLeaveCheck(forms) {
  $(forms).on('change, keyup', 'input, textarea, select', function() {
    $(this).parents('form').addClass('form-dirty')
    $('body').attr('data-turbolinks', false)
  })

  $(forms).on('submit', function() {
    $(this).removeClass('form-dirty')
    return true
  })

  $(window).on('beforeunload', function() {
    if ($('form.form-dirty').length > 0)
      return 'You have unsaved changes, are you sure you want to discard them?'
  })
}
