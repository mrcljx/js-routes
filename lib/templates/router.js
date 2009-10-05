%global% = new(function(routes) {
  this.url = window.location.toString().split('/').slice(0, 3).join('/');
  this.bindRoute = function(key, segments) {
    this[key] = function() {
      var route = '';
      var options = arguments[0] || {};
      var errors = [];
      var optionIndex = 0;
      for (var i = 0; i < segments.length; i++) {
        var segment = segments[i];
        if (segment.key) {
          var option = options[segment.key];
          if (option || option === 0) {
            options[segment.key] = null;
          } else {
            option = arguments[optionIndex];
            optionIndex += 1;
          }
          if (segment.regexp) {
            if (option) {
              if (segment.regexp.test(option)) {
                route += option;
              } else {
                errors.push('`' + segment.key + '` (' + option + ') does not match requirements: ' + segment.regexp);
              }
            } else {
              errors.push('`' + segment.key + '` is required');
            }
          } else if (segment.key == 'format' && option) {
            route += '.' + option;
          } else if (!segment.is_optional) {
            if (option || option === 0) {
              route += option;
            } else {
               errors.push('`' + segment.key + '` is required');
            }
          }
        } else {
          if (!segment.is_optional) {
            route += segment.value;
          }
        }
      }
      if (errors.length > 0) {
        throw('Could not generate route for ' + key + ': ' + errors.join(", "));
      }
      var data = [];
      if (typeof(options) == 'object') {
        for (var parameter in options) {
          if (options[parameter]) {
            data.push(parameter + '=' + encodeURIComponent(options[parameter]));
          }
        }
      }
      if (data.length > 0) {
        data = data.join('&');
        if (route.indexOf('?') > 0) {
          route += data;
        } else {
          route += '?' + data;
        }
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