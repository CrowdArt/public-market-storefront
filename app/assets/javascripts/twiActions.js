window.pm = window.pm || {}

window.pm.shareOnTwitter = function(link, text) {
  var top = (screen.height / 2) - (570 / 2)
  var left = (screen.width / 2) - (520 / 2)

  var encodedText = encodeURIComponent(text)
  var encodedUrl = encodeURIComponent(link)

  window.open("https://twitter.com/intent/tweet?url=" + encodedUrl + "&text=" + encodedText + "related=publicmarket", 'sharer', "top=" + top + ",left=" + left + ",toolbar=0,status=0,width=520,height=570px")
}
