Spree.fetch_account = function() {
  return $.ajax({
    url: Spree.pathFor("account_link"),
    success: function(data) {
      $('#spree-header .link-to-account').remove();
      return $(data).insertBefore("li#link-to-cart");
    }
  });
};
