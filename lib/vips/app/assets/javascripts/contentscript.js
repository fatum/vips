//= require jquery-1.7.2.min
//= require jquery.textchildren
//= require vips/xpath
//= require vips/dom
//= require vips/renderer

var search_params = document.location.search;
var is_load_vips = search_params.indexOf('vips=true');

if (is_load_vips == 1) {
  var creator = new PageStructureCreator();
  var structure = creator.createStructure();

  console.log('Send extraction request to extension');
  chrome.extension.sendMessage({action: "extract", dom: structure}, function(response) {
    console.log('Receive response!');
    console.log(response);
    var json = eval('(' + response + ')');

    var active_level = search_params.match('vips_level=(.+)$')[1]

    var renderer = new Renderer()
    renderer.renderLevels(json.levels, active_level)
  });
}
