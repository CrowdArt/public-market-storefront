Spree.typeaheadSearch = function() {
  var products = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    limit: 10,
    remote: {
      url: '../autocomplete/products.json?keywords=%QUERY',
      wildcard: '%QUERY',
      cache: false
    }
  });

  products.initialize();

  // passing in `null` for the `options` arguments will result in the default
  // options being used
  $('#keywords').typeahead({
    minLength: 2,
    highlight: true,
    menu: $('.keyword-suggestions')
  }, {
    name: 'products',
    source: products,
    templates: {
      suggestion: function(product) {
        return "<div class='product-suggestion'> \
                  <div class='product-suggestion__image'> \
                    <img src='" + product.image + "'/> \
                  </div>\
                  <div> \
                    <div class='product-suggestion__name'>" + product.name + "</div> \
                    <div class='product-suggestion__price'>From: " + product.price + "</div> \
                  </div>\
                </div>";
      }
    }
  });

  $('#keywords').on('typeahead:selected', function(e, s) {
    $(this).typeahead("val", s.name); // fill name
  }).on('typeahead:select', function(e, s) {
    window.location = s.link; // redirect directly to product for S1
  }).on('typeahead:cursorchange', function(e, s, d) {
    $(this).val($(this).typeahead('val')); // disable suggestion fill
  });
}