Spree.loadMobileSubcategories = function() {
  // don't reload subtaxons if already loaded
  if ($('.mobile-menu__inner-wrapper .subcategories ul').length) return

  $.ajax({
    url: '/taxons/mobile_menu_childs',
    success: function(data) {
      $('.mobile-menu__inner-wrapper .subtaxon-toggle, .mobile-menu__inner-wrapper .subcategories').remove()
      return $(data).prependTo('.mobile-menu__inner-wrapper')
    }
  })
}
