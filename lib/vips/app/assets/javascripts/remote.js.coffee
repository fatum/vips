listenExtensionMessages = ->
  chrome.extension.onMessage.addListener (request, sender, sendResponse)->
    if request.action is "extract"
      console.log request.dom

