function toggleStripeInfo(visible) {
  $('#stripe-agreement').toggle(visible)
  $('#payment-form-button').toggleClass('col-md-offset-8 col-sm-offset-6', !visible)
}

$(document).on('turbolinks:load', function() {
  if ($('#checkout_form_payment').length) {
    if ($('#existing_cards').length)
      toggleStripeInfo(false)

    $('#use_existing_card_yes').click(function() {
      toggleStripeInfo(false)
      $('#existing_cards').show()
      $('#payment-methods').find('input, #bstate select').prop('disabled', true)
    })

    $('#use_existing_card_no').click(function() {
      toggleStripeInfo(true)
      $('#existing_cards').hide()
      $('#payment-methods').find('input, #bstate select').prop('disabled', false)
    })

    $('#checkout_form_payment input[type="radio"]:checked').click()
  }
})
