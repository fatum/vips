class window.Xpath
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

  getElementByXPath: (sValue)->
    console.log("Evaluate xpath: #{sValue}")
    a = document.evaluate(sValue, document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null)
    if (a.snapshotLength > 0)
      return a.snapshotItem(0)

  getPath: (element = null)->
    element = @element unless element
    return "#{element.tagName}[@id = '#{element.id}']" if element.id
    return element.tagName if element is document.body

    ix = 0
    siblings = element.parentNode.childNodes
    for sibling in siblings
      if sibling is element
        return this.getPath(element.parentNode) + "/" + element.tagName + "[#{ix + 1}]"
      if sibling.nodeType == 1 && sibling.tagName is element.tagName
        ix++

