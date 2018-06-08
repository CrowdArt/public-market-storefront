window.pm = window.pm || {}

// tags toggle
window.pm.manageFilterTags = function(el) {
  var action = el.checked ? 'add' : 'remove'

  if ($(el).is(':radio')) {
    $("input[name='" + $(el).prop('name') + "']").not('#' + $(el).prop('id')).each(function(idx, otherRadio) {
      $('#filter-tags').tagsinput('remove', { id: $(otherRadio).attr('id'), text: $(otherRadio).siblings('span').text() }, { preventTrigger: true })
    })
  }

  $('#filter-tags').tagsinput(action, { id: $(el).attr('id'), text: $(el).siblings('span').text() }, { preventTrigger: true })
}

$(document).on('change', "#taxon-filters-form input", function() {
  pm.manageFilterTags(this)
}).on('change', "#taxon-filters-form input", window.pm.debounce(function() {
  // bind separate listener to use debounce
  $(this).parents('form').submit()
}, 500))

$(document).on('ajax:beforeSend', '#taxon-filters-form', function() {
  $('#products').addClass('products-loading')
}).on('ajax:complete', function(xhr, status) {
  $('#products').removeClass('products-loading')
}).on('ajax:success', function(xhr, status) {
  history.pushState({}, '', '//' + location.host + location.pathname + '?' + $('#taxon-filters-form').serialize())
})

// disable closing dropdown on label click
$(document).on('click', '.taxon-filter .dropdown-menu label', function(e) {
  e.stopPropagation()
})

// uncheck inputs in filters
$(document).on('beforeItemRemove', '#filter-tags', function(event) {
  if (event.options && event.options.preventTrigger) return

  var item = $('#' + event.item.id)
  item.prop('checked', false)
  item.trigger('change')
})
