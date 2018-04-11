window.initStripeForm = function(key, formID) {
  Stripe.setPublishableKey(key)

  Spree.stripePaymentMethod = $(formID)

  var mapCC, stripeResponseHandler;

  mapCC = function(ccType) {
    if (ccType === 'MasterCard') {
      return 'mastercard';
    } else if (ccType === 'Visa') {
      return 'visa';
    } else if (ccType === 'American Express') {
      return 'amex';
    } else if (ccType === 'Discover') {
      return 'discover';
    } else if (ccType === 'Diners Club') {
      return 'dinersclub';
    } else if (ccType === 'JCB') {
      return 'jcb';
    }
  };

  stripeResponseHandler = function(status, response) {
    var paymentMethodId, token;

    if (response.error) {
      $('#stripeError').html(response.error.message);
      var param_map = {
        number:    '#card_number',
        exp_month: '#card_expiry',
        exp_year:  '#card_expiry',
        cvc:       '#card_code',
      }

      if (response.error.param) {
        errorField = Spree.stripePaymentMethod.find(param_map[response.error.param])
        errorField.addClass('error');
        errorField.parent().addClass('has-error');
      }

      return $('#stripeError').show();
    } else {
      Spree.stripePaymentMethod.find('#card_number, #card_expiry, #card_code').prop("disabled", true);
      Spree.stripePaymentMethod.find(".ccType").prop("disabled", false);
      Spree.stripePaymentMethod.find(".ccType").val(mapCC(response.card.brand));
      token = response['id'];
      // paymentMethodId = Spree.stripePaymentMethod.prop('id').split("_")[2];
      Spree.stripePaymentMethod.append("<input type='hidden' class='stripeToken' name='credit_card[gateway_payment_profile_id]' value='" + token + "'/>");
      Spree.stripePaymentMethod.append("<input type='hidden' class='stripeToken' name='credit_card[last_digits]' value='" + response.card.last4 + "'/>");
      Spree.stripePaymentMethod.append("<input type='hidden' class='stripeToken' name='credit_card[month]' value='" + response.card.exp_month + "'/>");
      Spree.stripePaymentMethod.append("<input type='hidden' class='stripeToken' name='credit_card[year]' value='" + response.card.exp_year + "'/>");
      Spree.stripePaymentMethod.append("<input type='hidden' class='stripeToken' name='credit_card[funding]' value='" + response.card.funding + "'/>");
      return Spree.stripePaymentMethod.trigger('submit');
    }
  };

  $(document).ready(function() {
    Spree.stripePaymentMethod.prepend("<div id='stripeError' class='errorExplanation alert alert-danger' style='display:none'></div>");

    return Spree.stripePaymentMethod.find("input[type='submit']").click(function() {
      var expiration, params;

      $('#stripeError').hide();
      Spree.stripePaymentMethod.find('.error, .has-error').removeClass('error, has-error');

      if (!$.payment.validateCardCVC($('#card_code').val())) {
        $('#card_code').addClass('error').parent().addClass('has-error');
        $('#stripeError').html('Security Code is invalid').show();
        return false;
      }

      if (!Spree.newCreditCard) {
        return Spree.stripePaymentMethod.parents("form").trigger('submit');
      } else {
        if (Spree.stripePaymentMethod.is(':visible')) {
          expiration = $('.cardExpiry:visible').payment('cardExpiryVal');

          params = $.extend({
            number: $('.cardNumber:visible').val(),
            cvc: $('.cardCode:visible').val(),
            exp_month: expiration.month || 0,
            exp_year: expiration.year || 0
          }, Spree.stripeAdditionalInfo());

          Stripe.card.createToken(params, stripeResponseHandler);

          return false;
        }
      }
    });
  });

  Spree.stripeAdditionalInfo = function() {
    var form = Spree.stripePaymentMethod
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