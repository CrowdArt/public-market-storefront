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
