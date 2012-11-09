class PageStructureCreator
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
    (new XpathFinder(element.get()[0])).getPath()

  getChildren: (element)->
    (this.createDomElement(child, element) for child in element.children() when $(child).prop('tagName').toLowerCase() isnt 'script')


class window.BlockCreator
  APP_VIP_SERVER = "http://localhost:9393/extract"

  createBlocks: ->
    structureCreator = new PageStructureCreator()
    dom = structureCreator.createStructure()
    this.extractBlocksFromDom(dom)

  extractBlocksFromDomXDM: (dom)->
    rpc = new easyXDM.Rpc({
        remote: APP_VIP_SERVER
    },
    {
        remote: {
            request: {}
        }
    })
    rpc.request({
        url: APP_VIP_SERVER + "extract/",
        method: "POST",
        data: {foo: "bar", bar: "foo"}
    }, (response)->
      alert response.data
    )

  extractBlocksFromDom: (dom)->
    $.ajax(
      url: APP_VIP_SERVER,
      type: "post",
      data: dom: dom, url: window.location.href,
      success: (response)->
        console.log response
    )

class XpathFinder
  constructor: (@element)->
  getXY:->
    x = 0
    y = 0
    element = @element
    while element
      x += element.offsetLeft
      y += element.offsetTop
      element = element.offsetParent
    [x, y]
  getPath: (element = null)->
    element = @element unless element
    return "id(#{element.id})" if element.id
    return element.tagName if element is document.body

    ix = 0
    siblings = element.parentNode.childNodes
    for sibling in siblings
      if sibling is element
        return this.getPath(element.parentNode) + "/" + element.tagName + "[#{ix + 1}]"
      if sibling.nodeType == 1 && sibling.tagName is element.tagName
        ix++

