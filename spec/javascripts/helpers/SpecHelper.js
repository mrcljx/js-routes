var fs = require('fs');

var template = fs.readFileSync('lib/templates/router.js').toString();
var script = template.replace('%routes%', '{}').replace('%global%', 'Router');

var window = {
  location: 'http://example.com/deeply/nested/path.html'
};

eval(script);
