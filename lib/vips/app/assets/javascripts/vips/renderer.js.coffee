class window.Renderer
  constructor: (@json) ->

  renderBlocks: (blocks) ->
    for block in blocks
      console.log("Processing #{block}...")
      element = this.getElementByXPath("//#{block}")
      element.addClass('vips-block')

      #dummy = $('<div></div>')
      #dummy.offset(
      #  element.offset()
      #)

      #dummy.width(element.width())
      #dummy.height(element.width())
      #dummy.addClass('vips-dummy')

      element.css(
        'border': 'double',
        #'z-index': 1000000,
        #'position': 'absolute'
      )
      #$('body').append(dummy)

  getElementByXPath: (xpath) ->
    $((new Xpath()).getElementByXPath(xpath))
