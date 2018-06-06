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

Spree.initTaxonFilter = function() {
  var filterForm = $('#taxon-filters-form')

  var manageFilterTags = function(el) {
    var action = el.checked ? 'add' : 'remove'
    $('#filter-tags').tagsinput(action, { id: $(el).attr('id'), text: $(el).siblings('span').text() }, { preventTrigger: true })
  }

  $("#taxon-filters-form input").change(function() {
    manageFilterTags(this)
    $(this).parents('form').submit()
  })

  filterForm.on('ajax:beforeSend', function() {
    $('#products').addClass('products-loading')
  }).on('ajax:complete', function(xhr, status) {
    $('#products').removeClass('products-loading')
  }).on('ajax:success', function(xhr, status) {
    history.pushState({}, '', '//' + location.host + location.pathname + '?' + $(this).serialize())
  })

  // disable closing dropdown on label click
  $('.taxon-filter .dropdown-menu label').on('click', function(e) {
    e.stopPropagation()
  })

  $('#filter-tags').tagsinput({
    tagClass: 'upcase label label-primary',
    itemValue: 'id',
    itemText: 'text'
  })

  // uncheck inputs in filters
  $('#filter-tags').on('beforeItemRemove', function(event) {
    var item = $('#' + event.item.id)
    item.prop('checked', false)

    if (!event.options || !event.options.preventTrigger)
      item.trigger('change')
  })

  // add initial tags
  $('#taxon-filters-form input:checked').each(function(){
    manageFilterTags(this)
  })
}
