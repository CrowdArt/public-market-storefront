$(document).ready(function() {
  $('#use_existing_card_yes').click(function() {
    $('#stripe-agreement').hide()
    $('#payment-form-button').addClass('col-md-offset-8 col-sm-offset-6')
  })

  $('#use_existing_card_no').click(function() {
    $('#stripe-agreement').show()
    $('#payment-form-button').removeClass('col-md-offset-8 col-sm-offset-6')
  })
})
