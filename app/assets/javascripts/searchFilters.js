window.pm = window.pm || {}

// tags toggle
window.pm.manageFilterTags = function(el) {
  var action = null
  var elementId = $(el).attr('id')
  var value = $(el).val().trim()

  // tags value equals text in filter if checkbox/radio
  if ($(el).is(':checkbox') || $(el).is(':radio')) {
    action = el.checked ? 'add' : 'remove'
    value = $("label[for='" + elementId + "']").text()
  } else if ($(el).prop('name') === 'keywords') {
    // remove old keyword tag
    $('#filter-tags').tagsinput('remove', { id: elementId }, { preventTrigger: true })

    if (value !== '') {
      action = 'add'
      value = 'Search: ' + value
    }
  }

  // remove other tags related to radio
  if ($(el).is(':radio')) {
    $("input[name='" + $(el).prop('name') + "']").not('#' + $(el).prop('id')).each(function(idx, otherRadio) {
      var otherId = $(otherRadio).attr('id')
      $('#filter-tags').tagsinput('remove', { id: otherId, text: $("label[for='" + otherId + "']").text() }, { preventTrigger: true })
    })
  }

  $('#filter-tags').tagsinput(action, { id: elementId, text: value }, { preventTrigger: true })
}

// defined not in searchFilterTags to avoid binding of multiple listeners
$(document).on('change', "#search-filters-form input", function() {
  pm.manageFilterTags(this)
}).on('change', "#search-filters-form input", window.pm.debounce(function() {
  // bind separate listener to use debounce
  $(this).parents('form').submit()
}, 500))

$(document).on('change', '#per_page_selector', function() {
  $('#search-filters-form #per_page').val($(this).val()).trigger('change')
})

$(document).on('ajax:beforeSend', '#search-filters-form', function() {
  $('#products').addClass('products-loading')
  $('#per_page_selector').attr('disabled', true)
}).on('ajax:complete', function(xhr, status) {
  $('#products').removeClass('products-loading')
  $('#per_page_selector').attr('disabled', false)
}).on('ajax:success', function(xhr, status) {
  history.pushState({}, '', '//' + location.host + location.pathname + '?' + $('#search-filters-form').serialize())
})

// disable closing dropdown on label click
$(document).on('click', '.search-filter .dropdown-menu label', function(e) {
  e.stopPropagation()
})

// uncheck inputs in filters
$(document).on('beforeItemRemove', '#filter-tags', function(event) {
  if (event.options && event.options.preventTrigger) return

  var item = $('#' + event.item.id)

  if (item.is(':checkbox') || item.is(':radio')) {
    item.prop('checked', false)
  } else {
    // allow to clear by name to remove top nav keyword input
    var inputName = item.prop('name')
    $("input[name='" + inputName + "']").val('')
  }

  item.trigger('change')
})
