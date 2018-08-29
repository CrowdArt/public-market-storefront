// additional to spree/frontend/product.js
function initializeProductPage() {
  if ($.fancybox) {
    $.fancybox.defaults.hash = false;
    $.fancybox.defaults.buttons = ['zoom', 'close'];
  }

  function setVariantOptionText(variant) {
    $('#variant-option').text(variant.closest('.dropdown-item').find('.variant-description').text());
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

  function setVendorInfo(variant) {
    $('#vendor-link').prop('href', variant.data('vendor-path')).text(variant.data('vendor'));
    $('#vendor-rep').text(variant.data('vendor-rep'));
  }

  function setRewards(variant) {
    $('.est-token-rewards span').text(variant.data('rewards'));
  }

  function setVariantPrice(variant) {
    var variantPrice = variant.data("price");

    if (variantPrice) {
      return ($(".price.selling")).text(variantPrice);
    }
  }

  Spree.changeQuantitySelectorOptions = function (count) {
    var $el = $("#cart-form #quantity");
    $el.empty(); // remove old options

    var max = count > 50 ? 50 : count;
    for (var i = 1; i <= max; i++) {
      $el.append($("<option></option>")
        .attr("value", i).text(i));
    }

    var lowStock = max < 10
    $('.buy-box--quntity-left--value').text(max)
    $('.buy-box--quntity-left').toggleClass('hide', !lowStock)
  }

  Spree.variantSelected = function(variant) {
    setVariantOptionText(variant);
    setAveragePrice(variant);
    setVendorInfo(variant);
    setRewards(variant);
    setVariantPrice(variant);
    Spree.changeQuantitySelectorOptions(variant.data("quantity"));
  }

  $(document).on('mouseenter', '#product-thumbnails li', function (event) {
    if ($(event.currentTarget).hasClass('thumb-selected')) return

    var imgLink = $(event.currentTarget).find('a').attr('href')

    $('#product-thumbnails li.thumb-selected').removeClass('thumb-selected')
    $(event.currentTarget).addClass('thumb-selected')

    $('#main-image a').attr('href', imgLink)
    $('#main-image img').fadeTo(150, 0.30, function() {
      $(this).attr('src', imgLink)
    }).fadeTo(150, 1)
  })
}

$(document).on('turbolinks:load', function() {
  var radios = $("#product-variants input[type='radio']");

  initializeProductPage()

  if (radios.length > 0) {
    var selectedRadio = $("#product-variants input[type='radio'][checked='checked']");

    Spree.variantSelected(selectedRadio);

    radios.click(function (event) {
      Spree.variantSelected($(this));
    });
  }
});
