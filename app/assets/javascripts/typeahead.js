//= require corejs-typeahead/dist/bloodhound.js
//= require corejs-typeahead/dist/typeahead.jquery.js

Spree.typeaheadSearch = function() {
  var products = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    limit: 10,
    remote: {
      url: '/autocomplete/products.json?taxon_id=%taxon_id&keywords=%QUERY',
      wildcard: '%QUERY',
      cache: false,
      replace: function (url, uriEncodedQuery) {
        // dynamically build url with current department
        return url.replace('%taxon_id', $('#navbar-taxon').val()).replace('%QUERY', uriEncodedQuery)
      }
    }
  });

  products.initialize();

  $('#nav-keyword').typeahead({
    minLength: 2,
    highlight: true,
    menu: $('.keyword-suggestions')
  }, {
    name: 'products',
    source: products,
    displayKey: 'name',
    templates: {
      suggestion: function(product) {
        var template = "<div class='product-suggestion'> \
                          <div class='product-suggestion__image'> \
                            <img src='" + product.image + "'/> \
                          </div>\
                          <div class='product-suggestion__info'> \
                            <div class='product-suggestion__name ellipsis'>" + product.name + "</div>"

        if (product.subtitle_presentation)
         template += "<div class='product-suggestion__subtitle ellipsis'>" + product.subtitle_presentation + "</div>"

        template += "<div class='product-suggestion__price'>From: " + product.price + "</div> \
                  </div>\
                </div>"

        return template
      }
    }
  });
}

$(document).on('turbolinks:load', Spree.typeaheadSearch)

$(document).on('typeahead:select', '#nav-keyword', function(e, s) {
  if (typeof mixpanel !== "undefined") {
    var taxonomy = $('#taxon-menu .name').text();
    var keyword = $('#nav-keyword').typeahead('val');

    mixpanel.track("product search selection", {
      "taxonomy": taxonomy,
      "keywords": keyword,
      "selection": s
    });
  };

  window.location = s.link; // redirect directly to product for S1
})
