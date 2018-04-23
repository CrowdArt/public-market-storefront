// additional to spree/frontend/product.js

$(document).on('turbolinks:load', function() {
  function setVariantOptionText(variant) {
    $('#variant-option').text(variant.siblings('label').find('.variant-description').text());
  }

  function setPriceDiff(variant, avgPrice) {
    var avgPrice = parseFloat(avgPrice.substring(1));
    var variantPrice = variant.data("price").substring(1);
    var showSaving = variantPrice < avgPrice

    if (showSaving) {
      var diff = (avgPrice - variantPrice).toFixed(2)
      var diffPercentage = Math.round(diff / avgPrice * 100)
      var diffText = "$" + diff + " (" + diffPercentage + "%)"

      $('#price-diff').text(diffText);
      $('#price-diff-percentage').text("(" + diffPercentage + ")");
    }

    $('#average-price').toggleClass('strike', showSaving)
    $('#price-diff').parent().toggleClass('hide', !showSaving)
  }

  function setAveragePrice(variant) {
    var avgPrice = variant.data("avg-price");

    if (avgPrice) {
      $("#average-price").text(avgPrice);
      setPriceDiff(variant, avgPrice);
    }
  };

  Spree.changeQuantitySelectorOptions = function(count) {
    var $el = $("#cart-form #quantity");
    $el.empty(); // remove old options

    var max = count > 50 ? 50 : count;
    for (var i = 1; i <= max; i++) {
      $el.append($("<option></option>")
         .attr("value", i).text(i));
    }

    var singleItemLeft = max === 1;
    $el.prop('disabled', singleItemLeft);
    $('#product-hidden-quantity').attr('disabled', !singleItemLeft);
  }

  var radios = $("#product-variants input[type='radio']");

  if (radios.length > 0) {
    var selectedRadio = $("#product-variants input[type='radio'][checked='checked']");

    setVariantOptionText(selectedRadio);
    setAveragePrice(selectedRadio);
    Spree.changeQuantitySelectorOptions(selectedRadio.data("quantity"));

    radios.click(function (event) {
      setVariantOptionText($(this));
      setAveragePrice($(this));
      Spree.changeQuantitySelectorOptions($(this).data("quantity"));
    });
  }
});
