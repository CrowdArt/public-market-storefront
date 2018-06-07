Spree.loadMobileSubcategories = function() {
  // don't reload subtaxons if already loaded
  if ($('.mobile-menu__inner-wrapper .subtaxon-toggle').length) return

  $.ajax({
    url: '/taxons/mobile_menu_childs',
    success: function(data) {
      return $(data).prependTo('.mobile-menu__inner-wrapper')
    }
  })
}
