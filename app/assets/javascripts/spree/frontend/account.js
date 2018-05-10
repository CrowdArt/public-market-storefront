Spree.fetch_account = function() {
  return $.ajax({
    url: Spree.pathFor("account_link"),
    success: function(data) {
      $('#spree-header .nav-buttons .link-to-account').remove();
      return $(data).insertBefore(".nav-buttons li#link-to-cart");
    }
  });
};
