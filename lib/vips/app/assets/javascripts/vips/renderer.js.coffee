class window.Renderer
  renderLevels: (levels, active) ->
    console.log "Detected #{levels.length} levels!"

    i = 0
    for level in levels
      console.log("Level #{++i} have blocks:")
      for block in level.blocks
        console.log("Block #{block.xpath}")
        console.log("--- width #{block.width}")
        console.log("--- height #{block.height}")
        console.log("--- left #{block.left}")
        console.log("--- top #{block.top}")

    this.renderBlocks(levels[active-1].blocks)
    this.renderSeparators(levels[active-1].separators)

  renderSeparators: (separators) ->
    for separator in separators
      element = $(document.createElement('div'))
      element.css(separator)
      element.css(
        'border': 'double',
        'color': 'red',
        'position': 'absolute'
      )

      element.addClass('separator')
      $('body').append(element)

  renderBlocks: (blocks) ->
    for block in blocks
      console.log("Processing #{block.xpath}...")
      element = this.getElementByXPath("//#{block.xpath}")

      element.addClass('vips-block')

      element.css(
        'border': 'double',
      )

  getElementByXPath: (xpath) ->
    $((new Xpath()).getElementByXPath(xpath))
