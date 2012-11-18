//= require jquery-1.7.2.min
//= require jquery.textchildren
//= require vips/xpath
//= require vips/dom
//= require vips/renderer

var creator = new PageStructureCreator();
var structure = creator.createStructure();

console.log('Send extraction request to extension');
chrome.extension.sendMessage({action: "extract", dom: structure}, function(response) {
  console.log('Receive response!');
  var json = eval('(' + response + ')');

  var renderer = new Renderer(json)
  renderer.renderBlocks(json.blocks)

  //renderer.renderSeparators(json.separators)
});
