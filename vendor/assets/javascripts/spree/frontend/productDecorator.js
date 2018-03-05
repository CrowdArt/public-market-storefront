$(document).ready(function() {
  function setVariantOptionText(variant) {
    $('#variant-option').text(variant.siblings('label').find('.variant-description').text());
  }

  function setPriceDiff(variant) {
    var avgPrice = parseFloat($('#average-price').text().substring(1));
    var variantPrice = variant.data("price").substring(1);
    var showSaving = variantPrice < avgPrice

    if (showSaving) {
      var diff = avgPrice - variantPrice
      var diffPercentage = diff / avgPrice * 100
      var diffText = "$" + diff + " (" + diffPercentage + "%)"

      $('#price-diff').text(diffText);
      $('#price-diff-percentage').text("(" + diffPercentage + ")");
    }

    $('#price-diff').parent().toggleClass('hide', !showSaving)
  }

  var radios = $("#product-variants input[type='radio']");

  if (radios.length > 0) {
    var selectedRadio = $("#product-variants input[type='radio'][checked='checked']");

    setVariantOptionText(selectedRadio);
    setPriceDiff(selectedRadio);

    radios.click(function (event) {
      setVariantOptionText($(this));
      setPriceDiff($(this));
    });
  }
})
