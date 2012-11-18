class window.Renderer
  constructor: (@json) ->

  renderBlocks: (blocks) ->
    console.log blocks
    for block in blocks
      console.log("Processing #{block}...")
      this.getElementByXPath("//#{block}").css('border-color': 'black')

  getElementByXPath: (xpath) ->
    $((new Xpath()).getElementByXPath(xpath))

