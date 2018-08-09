Spree.enableCharacterCounters = function() {
  var refreshCounter = function(counter, input) {
    return function() {
      currentLength = input.val().length;
      counter.find('.current').text(currentLength);
    }
  }

  $('.character-counter:not(.live').each(function(idx, el) {
    var input = $(el).prev('textarea, input');
    var counter = $(el);
    var refresh = refreshCounter(counter, input);
    input.on('keydown keyup', refresh);
    refresh();

    counter.find('.max').text(input.prop('maxlength'));
    counter.addClass('live');
  })
}