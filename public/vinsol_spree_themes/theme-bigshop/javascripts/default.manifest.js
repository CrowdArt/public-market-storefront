// all javascript files related to themes should be require in this manifest.
//= require slick.min


$(document).on('ready', function() {

  // Home Page Slider
  $(".regular").slick({
    infinite: true,
    slidesToShow: 1,
    slidesToScroll: 1
  });

  // All Responsive Tables
  $( ".table" ).wrap( "<div class='table-responsive'></div>" );

  // For Header Responsive
  $(".search_toggle").click(function(){
    $(".search_area").toggleClass("search_open");
  });

  $(".userbar_toggle").click(function(){
    $("#top-nav-bar").toggleClass("userbar_open");
  });

    $(".sidebar_toggle").click(function(){
    $("#sidebar").toggleClass("sidebar_open");
  });

});
