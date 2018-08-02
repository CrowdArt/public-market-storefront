// addition to spree/cart.js.coffee

$(document).on('click', "#update-cart button[type='submit']", function() {
  var outOfStockModal = $('#out-of-stock-modal')

  if (outOfStockModal.length > 0) {
    outOfStockModal.modal('show')
    return false
  }
})

$(document).on('click', '#remove-out-of-stock', function() {
  // set quantity of out of stock items to 0
  $('input.out-of-stock-input').val(0)
  $('#update-cart').submit()
})
