window.pm = window.pm || {}
window.pm.initRichDropDown = function () {
  console.log('test')
  $(document).on('click', '.rich-dropdown .dropdown-menu a', function (e) {
    console.log(e)
    e.preventDefault()
  })
}