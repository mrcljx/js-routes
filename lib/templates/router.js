%global% = new(function(routes) {
  this.url = window.location.toString().split('/').slice(0, 3).join('/');
  this.bindRoute = function(key, segments) {
    this[key] = function() {
      var route = '';
      var options = arguments[0] || {};
      var errors = [];
      for (var i = 0; i < segments.length; i++) {
        var segment = segments[i];
        if (segment.key) {
          if (segment.regexp) {
            if (options[segment.key]) {
              if (segment.regexp.test(options[segment.key])) {
                route += options[segment.key];
              } else {
                errors.push('`' + segment.key + '` (' + options[segment.key] + ') does not match requirements: ' + segment.regexp);
              }
            } else {
              errors.push('`' + segment.key + '` is required')
            }
          } else {
            alert('key required but no regexp');
          }
        } else {
          if (!segment.is_optional) {
            route += segment.value;
          }
        }
      }
      if (errors.length > 0) {
        throw(errors.join(", "));
      }
      return route;
    };

    this[key + '_path'] = function() {
      return this[key].apply(this, arguments);
    };

    this[key + '_url'] = function() {
      var route = this[key + '_path'].apply(this, arguments);
      return this.url + route;
    };
  };
  for (var key in routes) {
    this.bindRoute(key, routes[key]);
  }
  this.named_routes = routes;
  this.bindRoute = null;
})(%routes%);