$(document).on('turbolinks:load', function() {
  if ($('#checkout_form_address #existing_addresses').length) {
    $('#use_existing_address_yes').click(function() {
      $("#new-address-form").hide();
      $("#new-address-form").find('input, select').prop('disabled', true)

      $('.existing-address-radio').prop('disabled', false)

      $('#existing_addresses').show()
    })

    $('#use_existing_address_no').click(function() {
      $("#new-address-form").show();
      $("#new-address-form").find('input, select').prop('disabled', false)

      $('.existing-address-radio').prop('disabled', true)

      $('#existing_addresses').hide()
    })

    $('#checkout_form_address input[type="radio"]:checked').click()
  }
})
