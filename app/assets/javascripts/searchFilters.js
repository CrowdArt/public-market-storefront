window.pm = window.pm || {}

// tags toggle
window.pm.manageFilterTags = function(el) {
  var action = null
  var elementId = $(el).data('tag-id')
  var value = $(el).val().trim()

  // tags value equals text in filter if checkbox/radio
  if ($(el).is(':checkbox, :radio')) {
    action = el.checked ? 'add' : 'remove'
    value = $(el).siblings('label').text()
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
    $("input[name='" + $(el).prop('name') + "']:not(:checked)").not('#' + $(el).prop('id')).each(function(idx, otherRadio) {
      var otherId = $(otherRadio).attr('id')
      $('#filter-tags').tagsinput('remove', { id: otherId, text: $("label[for='" + otherId + "']").text() }, { preventTrigger: true })
    })
  }

  $('#filter-tags').tagsinput(action, { id: elementId, text: value }, { preventTrigger: true })
}

window.pm.setSelectionsCount = function() {
  var filtersCount = $("#mobile-search-filters-form input:checked").length
  var hideSelections = filtersCount == 0
  var filtersHeadText = hideSelections ? 'FILTERS & SORTING' : 'SELECTIONS'

  $('.mobile-filters-selections--head-hint').text(filtersHeadText)
  $('.mobile-filters-selections-counter').text(" (" + filtersCount + ")")
  $('.mobile-filters-selections-counter, .mobile-filters-btn-all, #clear-mobile-filters').toggleClass('hide', hideSelections)
}

function syncOtherForm(el) {
  if ($(el).is(':radio, :checkbox')) {
    $("input[name='" + $(el).prop('name') + "'][value='" + $(el).val() + "']").not('#' + $(el).prop('id')).each(function(idx, otherRadio) {
      $(otherRadio).prop('checked', $(el).prop('checked'))
    })
  }
}

// defined not in searchFilterTags to avoid binding of multiple listeners
$(document).on('change', '#search-filters-form input', function() {
  pm.manageFilterTags(this)
  syncOtherForm(this)
}).on('change', "#search-filters-form input", window.pm.debounce(function() {
  // bind separate listener to use debounce
  $(this).parents('form').submit()
}, 500))

$(document).on('change', '#per_page_selector', function() {
  $("input[name='per_page']").val($(this).val()).trigger('change')
})

$(document).on('ajax:success', '#search-filters-form, #mobile-search-filters-form', function(xhr, status) {
  history.pushState(history.state, null, '//' + location.host + location.pathname + '?' + $(this).serialize())
})

$(document).on('submit', '#mobile-search-filters-form', function() {
  $(this).find('input').each(function() {
    pm.manageFilterTags(this)
    syncOtherForm(this)
  })

  $('#mobile-filters-toggle').prop('checked', false).trigger('change')
})

$(document).on('click', '#clear-mobile-filters', function() {
  $('#mobile-search-filters-form input').prop('checked', false)
  pm.setSelectionsCount()
})

$(document).on('change', '#mobile-search-filters-form input', function() {
  pm.setSelectionsCount()
})

$(window).on('popstate', function (e) {
  if ($('#search-filters-form').length > 0)
    $('.site-content-wrap').addClass('content-loading')
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
    item.attr('checked', false)
  } else {
    // allow to clear by name to remove top nav keyword input
    var inputName = item.prop('name')
    $("input[name='" + inputName + "']").val('')
  }

  item.trigger('change')
})
