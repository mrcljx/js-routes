/*!
 * jsRoutes (http://github.com/sirlantis/js-routes)
 * Copyright (c) 2010-2011 Marcel Jackwerth (marceljackwerth@gmail.com)
 * Licensed under the MIT license.
 */
RouterClass = function(routes) {
  this.url = window.location.toString().split('/').slice(0, 3).join('/');

  /*
   * Some patches and missing functions from standard JS
   */

  var toString = Object.prototype.toString;
  var isObject = function(o) {
    return o === Object(o);
  };
  var isArray = Array.isArray || function(obj) {
    return toString.call(obj) === '[object Array]';
  };

  /*
   * Helper functions
   */

  // remove left-over optional path variables
  this.cleanupPath = function(path) {
    return path.replace(/\(.*(\:[a-z0-9_]+).*\)/g, "").replace(/[\(\)]/g, "");
  };

  var jQuerySerializeParams = (typeof(jQuery) !== 'undefined' && jQuery.param);
  this.serializeParams = jQuerySerializeParams || function(obj) {
    var k, data = [];

    for (k in obj) {
      if (obj.hasOwnProperty(k)) { // mute JSlint
        var v = obj[k];
        if (v.length) {
          for (i = 0; i < v.length; i++) {
            data.push(encodeURIComponent(k) + '[]=' + encodeURIComponent(v[i]));
          }
        } else {
          data.push(encodeURIComponent(k) + '=' + encodeURIComponent(v));
        }
      }
    }

    return data.join('&');
  };

  var regExpEscape = function(text) {
    return text.replace(/[\-\[\]\{\}\(\)\*\+\?\.\,\\\^\$\|#\s]/g, "\\$&");
  };

  var OrderedHash = function() {
    this.keys = [];
    this.values = [];

    this.indexOfKey = function(key) {
      var i;
      for (i = 0; i<this.keys.length; i++){
        if (this.keys[i] === key){
          return i;
        }
      }
      return -1;
    };

    this.set = function(key, value) {
      var index = this.indexOfKey(key);
      if (index >= 0) {
        this.values[index] = value;
      } else {
        this.keys.push(key);
        this.values.push(value);
      }
    };

    this.get = function(key) {
      var index = this.indexOfKey(key);
      if (index >= 0) {
        return this.values[index];
      } else {
        return null;
      }
    };

    this.each = function(callback) {
      var i;
      for (i = 0; i < this.keys.length; i++) {
        callback(this.keys[i], this.values[i]);
      }
    };
  };

  this.resolveArguments = function(def, allArgs) {
    var i, k;
    var args = allArgs;
    var options = {};
    var urlOptions = new OrderedHash();

    // extract options
    if (allArgs.length > 0) {
      var last = allArgs[allArgs.length-1];
      if (isObject(last)) {
        options = last;
        args = [];
        for (i = 0; i < allArgs.length - 1; i++) {
          args.push(allArgs[i]);
        }
      }
    }

    for (i = 0; i < args.length; i++) {
      var key = def.keys[i];
      if (typeof(key) !== "undefined") {
        var value = args[i];
        urlOptions.set(key, value);
      }
    }

    for (k in options) {
      if (options.hasOwnProperty(k)) {
        urlOptions.set(k, options[k]);
      }
    }

    return urlOptions;
  };

  this.bindRoute = function(key, def) {
    this[key] = function() {
      var args = this.resolveArguments(def, arguments);
      var path = def.path;
      var data = [];
      var queryParams = {};

      args.each(function(k,v) {
        var pathVar = ':' + k;
        if (path.search(pathVar) >= 0) {
          path = path.replace(new RegExp(regExpEscape(pathVar)), encodeURIComponent(v));
        } else {
          queryParams[k] = v;
        }
      });

      var route = this.cleanupPath(path);

      // append query variables
      var serializedParams = this.serializeParams(queryParams);
      if (serializedParams.length > 0) {
        if (route.indexOf('?') > 0) {
          route += serializedParams;
        } else {
          route += '?' + serializedParams;
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

  var key;
  for (key in routes) {
    if (routes.hasOwnProperty(key)) {
      this.bindRoute(key, routes[key]);
    }
  }

  this.named_routes = routes;
};

// var Router = new RouterClass({book: { keys: ["id"], path: "/books/:id" }});
// var example = Router.book_url(3, {withImage: true, authors: ["Stephen King" , "Edgar Allan Poe"]});

// Allows deep nesting with jQuery installed:
// var jqExample = Router.book_url(3, {withImage: true, filters: { authors: ["Stephen King" , "Edgar Allan Poe"] }});
