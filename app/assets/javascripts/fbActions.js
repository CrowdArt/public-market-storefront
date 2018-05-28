window.pm = window.pm || {}

window.pm.initFb = function(appId) {
  window.fbAsyncInit = function() {
    FB.init({
      appId: appId,
      autoLogAppEvents: true,
      xfbml: true,
      version: 'v3.0'
    });
  };

  (function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "https://connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
  } (document, 'script', 'facebook-jssdk'));
}

window.pm.shareOnFb = function(link, text) {
  FB.ui({
    method: 'share',
    href: link,
    quote: text
  }, function(response) {});
}
