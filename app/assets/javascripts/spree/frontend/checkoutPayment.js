window.pm = window.pm || {}

window.pm.initCreditCardFormToggle = function() {
  function toggleCreditCardForms() {
    var showExistingCards = $("input[name='use_existing_card']:checked").val() == 'yes'
    $('#existing_cards').toggle(showExistingCards)
    $('#payment-methods').find('input, #bstate select').prop('disabled', showExistingCards)
    $('#existing_cards input').prop('disabled', !showExistingCards)
  }

  $("input[name='use_existing_card']").click(function() {
    toggleCreditCardForms()
  })

  toggleCreditCardForms()
}


$(document).on('ajax:beforeSend', '#checkout-form', function() {
  $(this).addClass('checkout-loading')
}).on('ajax:error', '#checkout-form', function() {
  $(this).removeClass('checkout-loading')
})
