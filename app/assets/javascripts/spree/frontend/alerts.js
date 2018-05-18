window.pm = window.pm || {}

window.pm.initStickyAlert = function() {
  $('.alert-top').affix({
    offset: {
      top: function () {
        return (this.top = $('#spree-header').outerHeight(true))
      }
    }
  })
}
