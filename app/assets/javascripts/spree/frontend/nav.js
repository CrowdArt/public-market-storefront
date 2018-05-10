window.pm = window.pm || {}

window.pm.initNavHide = function() {
  var lastY = $(window).scrollTop();
  var navbarHeight = $('#spree-header').outerHeight();
  var scrolled = false

  // throttle, swap with lodash
  setInterval(function() {
    if (scrolled) {
      checkScroll();
      scrolled = false;
    }
  }, 250);

  var checkScroll = function() {
    var currY = $(this).scrollTop()
    var hideNav = currY > lastY && currY > navbarHeight;

    $('#spree-header').toggleClass('hide-up', hideNav)

    lastY = currY;
  };

  $(window).scroll(function(){
    scrolled = true;
  });
}
