window.pm = window.pm || {}
window.pm.initRichDropDown = function () {
  $(document).on('click', '.rich-dropdown .dropdown-item', function (e) {
    var button = $(e.target).closest('.rich-dropdown').find('button');
    var item = $(e.target).closest('label')
    button.html(item.html());
  })
}
