class window.Renderer
  renderLevels: (levels) ->
    console.log "Detected #{levels.length} levels!"

    i = 0
    for level in levels
      this.renderBlocks(level.blocks, i++)
      this.renderSeparators(level.separators)

  renderSeparators: (separators) ->
    console.log separators

  renderBlocks: (blocks, level) ->
    for block in blocks
      console.log("Processing #{block}...")
      element = this.getElementByXPath("//#{block}")

      element.addClass('vips-block')
      element.addClass("level-#{level}")

      element.css(
        'border': 'double',
      )

  getElementByXPath: (xpath) ->
    $((new Xpath()).getElementByXPath(xpath))
