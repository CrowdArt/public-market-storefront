window.pm = window.pm || {}

window.pm.initPhoneInput = function(wrapperId) {
  var wrapper = $(wrapperId)
  var phoneInput = $(wrapperId + ' input:not([type=hidden])')

  phoneInput.intlTelInput({
    utilsScript: 'https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/12.1.15/js/utils.js',
    preferredCountries: [],
    onlyCountries: ['us']
  }).done(function() {
    var phoneValueInput = $(wrapperId + ' input[type=hidden]')
    var errorHint = $(wrapperId + ' > span')

    var reset = function() {
      wrapper.removeClass('has-error');
      phoneValueInput.val(phoneInput.intlTelInput('getNumber'))
    }

    phoneInput.on('blur', function() {
      reset()

      if ($.trim(phoneInput.val()) && !phoneInput.intlTelInput('isValidNumber')) {
        errorHint.text('Invalid number')
        wrapper.addClass('has-error')
      }
    }).on('keyup change', reset)
  })
}
