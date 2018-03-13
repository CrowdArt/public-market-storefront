$(document).ready(function() {
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

  var radios = $("#product-variants input[type='radio']");

  if (radios.length > 0) {
    var selectedRadio = $("#product-variants input[type='radio'][checked='checked']");

    setVariantOptionText(selectedRadio);
    setAveragePrice(selectedRadio);

    radios.click(function (event) {
      setVariantOptionText($(this));
      setAveragePrice($(this));
    });
  }
})
