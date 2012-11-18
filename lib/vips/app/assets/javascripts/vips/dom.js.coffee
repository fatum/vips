class window.PageStructureCreator
  createDomElement: (element, parent) ->
    element = $(element)
    parent = parent.xpath if parent
    {
      tag_name: element.prop('tagName'),
      color: element.css('color'),
      background_color: element.css('background-color'),
      width: element.width(),
      height: element.height(),
      offset_top: element.offset().top,
      offset_left: element.offset().left,
      visible: element.is(':visible'),
      text: element.textChildren(),
      parent: parent,
      xpath: this.getXpath(element),
      children: this.getChildren(element)
    }

  createStructure: ->
    this.createDomElement($('body'), '')

  getXpath: (element)->
    (new Xpath(element.get()[0])).getPath().toLowerCase()

  getChildren: (element)->
    (this.createDomElement(child, element) for child in element.children() when $(child).prop('tagName').toLowerCase() isnt 'script')
