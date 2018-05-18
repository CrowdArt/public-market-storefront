window.pm = window.pm || {}

window.pm.initStickyAlert = function() {
  $('.alert-top-sticky').affix({
    offset: {
      top: function () {
        return (this.top = $('#spree-header').outerHeight(true))
      }
    }
  })
}
