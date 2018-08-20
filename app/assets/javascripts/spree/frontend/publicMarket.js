//= require_tree .

window.pm = window.pm || {}

// swap with lodash
window.pm.debounce = function(callback, delay) {
  var timeout
  return function() {
    var args = arguments
    clearTimeout(timeout)
    timeout = setTimeout(function() {
      callback.apply(this, args)
    }.bind(this), delay)
  }
}

$(document).on('click', 'a.show-more', function() {
  if ($(this).prev().hasClass('hide')) {
    $(this).text('Show less')
  } else {
    $(this).text('Read more')
  }

  $(this).prev().toggleClass('hide').prev().toggleClass('hide')
})

$(document).on('ajax:beforeSend', '.trigger-content-load-overlay', function() {
  $('.site-content-wrap').addClass('content-loading')
}).on('ajax:send', '.trigger-content-load-overlay', function(event, jqXHR) {
  jqXHR.always = function() {
    $('.site-content-wrap').removeClass('content-loading')
  }
})
