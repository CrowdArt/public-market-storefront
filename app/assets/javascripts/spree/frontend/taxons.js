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

Spree.initTaxonFilterTags = function(name) {
  $("input[name='" + name + "']").change(function() {
    var action = this.checked ? 'add' : 'remove'
    $('#filter-tags').tagsinput(action, { id: $(this).attr('id'), text: $(this).siblings('span').text() })
  })
}
