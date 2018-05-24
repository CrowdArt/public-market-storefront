window.pm = window.pm || {}

window.pm.initStripeForm = function(key, formID, paramPrefix) {
  var form = $(formID)
  var stripe = Stripe(key)
  var elements = stripe.elements()
  var tokenRetrieved = false

  var style = {
    base: {
      fontSize: '16px',
      fontFamily: "'Roboto', Helvetica, Arial, sans-serif",
      color: '#454a50'
    },
    invalid: {
      color: '#FF0039'
    }
  }

  var card = elements.create('card', { hidePostalCode: true, style: style })
  var cardWrapperId = '#new-stripe-card-wrapper'

  card.mount(cardWrapperId)

  card.addEventListener('change', function(event) {
    var displayError = document.getElementById('stripe-card-errors')
    if (event.error) {
      displayError.textContent = event.error.message
    } else {
      displayError.textContent = ''
    }
  })

  function createStripeToken(e) {
    // don't create new if card form is invisible
    if (!$(cardWrapperId).is(':visible')) return true

    e.preventDefault()

    stripe.createToken(card, stripeAdditionalInfo()).then(function(result) {
      if (result.error) {
        var errorElement = document.getElementById('stripe-card-errors')
        errorElement.textContent = result.error.message
        $('#checkout-form').removeClass('checkout-loading')
      } else {
        stripeTokenHandler(result.token)
      }
    })
  }

  form.on('ajax:beforeSend', function(event, xhr, status) {
    if (!$(cardWrapperId).is(':visible')) return true
    if (!tokenRetrieved) createStripeToken(event)
    return tokenRetrieved
  }).on('ajax:error', function(e) {
    tokenRetrieved = false
  })

  $('#toggle-credit-card-edit').on('click', function() {
    $('#new-stripe-card-wrapper, #credit-card-info').toggleClass('hide')
    $(this).text() == 'Cancel' ? $(this).text('Edit') : $(this).text('Cancel')
    $('#stripe-card-inputs input').prop('disabled', function(_, disabled) { return !disabled; })
  })

  function stripeTokenHandler(result) {
    var stripeInputs = $('#stripe-card-inputs')

    stripeInputs.empty()

    stripeInputs.append("<input type='hidden' class='stripeToken' name='" + paramPrefix + "[gateway_payment_profile_id]' value='" + result.id + "'/>")
    stripeInputs.append("<input type='hidden' class='stripeToken' name='" + paramPrefix + "[last_digits]' value='" + result.card.last4 + "'/>")
    stripeInputs.append("<input type='hidden' class='stripeToken' name='" + paramPrefix + "[month]' value='" + result.card.exp_month + "'/>")
    stripeInputs.append("<input type='hidden' class='stripeToken' name='" + paramPrefix + "[year]' value='" + result.card.exp_year + "'/>")
    stripeInputs.append("<input type='hidden' class='stripeToken' name='" + paramPrefix + "[funding]' value='" + result.card.funding + "'/>")
    stripeInputs.append("<input type='hidden' class='stripeToken' name='" + paramPrefix + "[cc_type]' value='" + result.card.brand.toLowerCase() + "'/>")

    tokenRetrieved = true

    form.trigger('submit')
  }

  function stripeAdditionalInfo() {
    return {
      name: form.find('#bfirstname input').val(),
      address_line1: form.find('#baddress1 input').val(),
      address_line2: form.find('#baddress2 input').val(),
      address_city: form.find('#bcity input').val(),
      address_zip: form.find('#bzipcode input').val(),
      address_state: form.find('#bstate select option:selected').data('stateCode'),
      address_country: form.find('#bcountry select option:selected').data('countryCode')
    }
  }
}
