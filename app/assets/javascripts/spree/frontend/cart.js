// override of cart.js.coffee

$(document).on('click', "#update-cart button[type='submit']", function() {
  var outOfStockModal = $('#out-of-stock-modal')

  if (outOfStockModal.length > 0) {
    outOfStockModal.modal('show')
    return false
  }
})

function removeLineItems(items) {
  items.prop('disabled', true)
  items.siblings('.hidden-line-item-quantity').prop('disabled', false)
  $('#update-cart').submit()
}

$(document).on('click', 'form#update-cart a.delete', function() {
  removeLineItems($(this).parents('.line-item').find('.line_item_quantity'))
  return false
})

$(document).on('click', '#remove-out-of-stock', function() {
  // set quantity of out of stock items to 0
  removeLineItems($('.out-of-stock-input'))
  return false
})

$(document).on('change', '#update-cart select, input', function() {
  $('#update-cart').submit()
})

$(document).on('ajax:beforeSend', '#update-cart', function() {
  $('#content').addClass('content-loading')
}).on('ajax:send', '#update-cart', function(event, jqXHR) {
  jqXHR.always = function() {
    $('#content').removeClass('content-loading')
  }
})

Spree.fetch_cart = function() {
  $.ajax({
    url: Spree.pathFor('cart_link'),
    success: function(data) {
      $('#link-to-cart').html(data)
    }
  })
}
