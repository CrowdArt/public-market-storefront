function initializeProductPage() {
  if ($.fancybox) {
    $.fancybox.defaults.hash = false;
    $.fancybox.defaults.buttons = ['zoom', 'close'];
  }

  Spree.changeQuantitySelectorOptions = function(count) {
    var $el = $('#buy-box #quantity');
    $el.empty(); // remove old options

    var max = count > 50 ? 50 : count;
    for (var i = 1; i <= max; i++) {
      $el.append($("<option></option>")
        .attr("value", i).text(i));
    }

    var lowStock = max < 10
    $('.buy-box--quantity-left--value').text(max)
    $('.buy-box--quantity-left').toggleClass('hide', !lowStock)
  }

  // thumbnail selector
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

  // TODO: implement generic scroller
  var similarItemsScrolling = false
  var similarItemsScroller = '.product-similar-items--scroller'
  var similarItemsControls = '.product-similar-items .left, .product-similar-items .right'

  if ($(similarItemsScroller).length == 0) return

  if ($(similarItemsScroller)[0].offsetWidth < $(similarItemsScroller)[0].scrollWidth) {
    $(similarItemsControls).fadeIn({ start: function() {
      $(this).css({ 'display': 'flex' })
    }})
  }

  $(document).on('mousedown', similarItemsControls, function (evt) {
    similarItemsScrolling = true
    startScrolling($(similarItemsScroller), $(similarItemsScroller).width() / 6, evt.target)
  }).on('mouseup', function () {
    similarItemsScrolling = false
  })

  function startScrolling(obj, spd, btn) {
    var step = $(btn).hasClass('left') ? '-=' + spd + 'px' : '+=' + spd + 'px'

    if (!similarItemsScrolling) {
      obj.stop()
    } else {
      obj.animate({
        'scrollLeft': step
      }, 'fast', function () {
        if (similarItemsScrolling) startScrolling(obj, spd, btn)
      })
    }
  }
}

$(document).on('turbolinks:load', function() {
  initializeProductPage()
})
