$(document).on('turbolinks:load', function() {
  Spree.fetch_cart()
  $('.mobile-menu-toggle').prop('checked', false).trigger('change')
})

// load subcategories on mobile menu open
$(document).one('change', '#mobile-nav-toggle', function() {
  Spree.loadMobileSubcategories()
})

$(document).on('change', '.mobile-menu-toggle', function() {
  $('body').toggleClass('mobile-menu-open', this.checked)
})

// close navbar on turbolinks visit
$(document).on('turbolinks:before-visit', function() {
  $('.mobile-menu-toggle').prop('checked', false).trigger('change')
})

$(document).on('click', '#taxon-dropdown a', function(e) {
  var taxonId = $(e.target).data('taxon-id')
  if (taxonId !== undefined) {
    $('#taxon-dropdown a').removeClass('checked')
    $(e.target).addClass('checked')
    $('#taxon-menu .name').text($(e.target).data('taxon-name'))
    $('#navbar-taxon').val($(e.target).data('taxon-id'))
  } else {
    e.stopPropagation()
  }
  e.preventDefault()
})

$(document).on('submit', '#navbar-keyword-form', function() {
  var filtersForm = $('#search-filters-form')
  // submit with redirect if no filters on page or deparment was changed
  var allowSubmit = filtersForm.length === 0 || ($('#filter_taxon').val() !== $('#navbar-taxon').val())

  if (!allowSubmit) {
    var navKeywordInput = $(this).find("input[name='keywords']")
    var topNavKeywordValue = navKeywordInput.val()
    // trigger filters form change
    $("input[name='keywords']").not('#' + navKeywordInput.prop('id')).val(topNavKeywordValue).trigger('change')
  }

  return allowSubmit
})

$(document).on('change, keyup', '#navbar-keyword-form #nav-keyword', function() {
  $(this).parents('form').toggleClass('filled', $(this).val().trim() !== '')
})
