function checkVariationOptionInUrl() {
  if (location.hash.length == 0) return

  var val = location.hash.substring(1)

  if ($('.similar-variants--filters').is(':visible')) {
    $("input[name='checkbox_variation'][value='" + val + "']").prop('checked', true).trigger('change')
  } else {
    $("input[name='radio_variation'][value='" + val + "']").prop('checked', true).trigger('change')
  }

  history.replaceState({}, document.title, location.pathname + location.search)
}

function isOptionsEmpty() {
  if ($("input[name='checkbox_variation']:checked").length == 0) {
    $(".similar-variants--table-body--row").show()
    return true
  }
}

function toggleVariations(variation, checked) {
  $("[data-variation~='" + variation + "'").toggle(checked)
}

$(document).on('change', "input[name='checkbox_variation']", function(e) {
  // check all if nothing selected
  if (isOptionsEmpty()) return

  var childs = $(this).parents('.root-variation-checkbox').find('.variation-child')

  if ($(this).hasClass('variation-root')) {
    // change all childs on parent check
    childs.prop('checked', this.checked)

    if (!this.checked && isOptionsEmpty()) return
  } else if (childs.length == 1) {
    // change with parent if only one child
    var parent = $(this).parents('.root-variation-checkbox').find('.variation-root')
    parent.prop('checked', this.checked).trigger('change')
    return
  }

  $("input[name='checkbox_variation']").each(function() {
    toggleVariations($(this).val(), this.checked)
  })
})

$(document).on('change', "input[name='radio_variation']", function(e) {
  var curVal = $("input[name='radio_variation']:checked").val()

  if (curVal == 'all') {
    $(".similar-variants--table-body--row").show()
  }

  $("input[name='radio_variation']").each(function() {
    $(this).parents('.similar-variants--table-header--item').toggleClass('active', this.checked)

    if (curVal == 'all') return

    toggleVariations($(this).val(), this.checked)
  })
})

$(document).on('click', '#clear-variation-filters-btn', function() {
  $(".similar-variants--table-body--row").show()
  $("input[name='checkbox_variation'], input[name='radio_variation']").prop('checked', false)
})

checkVariationOptionInUrl()
