window.listenExtensionMessages = ->
  chrome.extension.onMessage.addListener (request, sender, sendResponse)->
    if request.action is "extract"
      requestToVipsServer(request.dom, sendResponse)
    console.log 'Listen extract event...'
    true

requestToVipsServer =(dom, sendResponse)->
  console.log('Send request to vips server...')
  $.post('http://localhost/extract', {
    dom: dom, url: window.location.href
  }).complete (response)->
    if response.readyState == 4
      console.log('Response received')
      sendResponse(response.responseText)
    else
      console.log('Response failed..')
    console.log(response.responseText)
