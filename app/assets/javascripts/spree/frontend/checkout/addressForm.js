window.pm = window.pm || {}

window.pm.initAddressFormToggles = function(formAttr) {
  var form = $('#' + formAttr + '-address-fields-form')

  function toggleAddressForms() {
    var toggleInput = $("input[name='" + formAttr + "_use_existing_address']:checked")
    var toggleInputUseBilling = $("input[name='order_use_billing_address']:checked")
    var hideNewAddress = toggleInput.val() == 'yes' || toggleInputUseBilling.val() == 'yes'

    $(form).find('.address-fields-form--new-address').toggle(!hideNewAddress).find('input, #bstate select').prop('disabled', hideNewAddress)
    $(form).find('.address-fields-form--existing-addresses').toggle(hideNewAddress).find('input').prop('disabled', !hideNewAddress)
  }

  $("input[name='" + formAttr + "_use_existing_address'], input[name='order_use_billing_address']").click(function() {
    toggleAddressForms()
  })

  toggleAddressForms()
}
