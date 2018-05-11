Spree.fetch_account = function() {
  return $.ajax({
    url: Spree.pathFor("account_link"),
    success: function(data) {
      $('#spree-header .navbar-top-right .link-to-account').remove();
      return $(data).insertBefore(".navbar-top-right li#link-to-cart");
    }
  });
};
