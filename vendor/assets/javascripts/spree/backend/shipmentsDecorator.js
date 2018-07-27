// Shipments AJAX API
$(document).ready(function () {
  'use strict';

  $('.stock-item a.confirm').click(toggleItemEdit);
  $('.stock-item a.cancel').click(toggleItemEdit);

  $('a.save-item').off('click').click(function () {
    var save = $(this);
    var shipment_number = save.data('shipment-number');
    var variant_id = save.data('variant-id');
    var action = save.data('action')

    var quantity = parseInt(save.parents('tr').find('input.line_item_quantity').val());

    toggleItemEdit.bind(save)();

    var url = Spree.routes.shipments_api + "/" + shipment_number + "/" + action

    if (quantity > 0) {
      $('.stock-item a').addClass('disabled')
      $.ajax({
        type: "PUT",
        url: Spree.url(url),
        data: {
          variant_id: variant_id,
          quantity: quantity,
          token: Spree.api_key
        }
      }).done(function (msg) {
        window.location.reload();
      }).fail(function (msg) {
        alert(msg.responseJSON.message)
        $('.stock-item a').removeClass('disabled')
      });
    }
    // adjustShipmentItems(shipment_number, variant_id, quantity);
    return false;
  });
})

toggleItemEdit = function () {
  var link = $(this);
  link.parent().find('a.cancel').toggle();
  link.parent().find('a.confirm').toggle();
  link.parent().find('a.edit-item').toggle();
  link.parent().find('a.cancel-item').toggle();
  link.parent().find('a.split-item').toggle();
  link.parent().find('a.save-item').toggle().data('action', link.data('action'));
  link.parent().find('a.delete-item').toggle();
  link.parents('tr').find('td.item-qty-show').toggle();
  link.parents('tr').find('td.item-qty-edit').toggle();

  return false;
}

adjustShipmentItems = (function(spreeFunc) {
  return function (shipment_number, variant_id, quantity) {
    action =
    console.log(shipment_number, variant_id, quantity);
    debugger
    spreeFunc(shipment_number, variant_id, quantity);
  }
})(adjustShipmentItems);
