var fs = require('fs');
var jsdom = require('jsdom');

describe("Router", function() {
  var Router;

  beforeEach(function() {
    global.document = jsdom.jsdom("<html><head></head><body>hello world</body></html>");
    global.window = document.createWindow();

    var template = fs.readFileSync('lib/templates/router.js').toString();
    var script = template;

    eval(script);

    Router = new RouterClass({});
  });

  afterEach(function() {
    delete document;
    delete window;
  });

  it("should generate named routes", function() {

    // set location and reload the router
    window.location = "http://example.com/deeply/nested/path.html";
    Router = new RouterClass({});

    Router.bindRoute('sample', { path: '/sample', keys: [] });
    expect(Router.sample_path()).toEqual('/sample');
    expect(Router.sample_url()).toEqual('http://example.com/sample');
  });

  it('should interpolate parameters', function() {
    Router.bindRoute('post', { path: '/posts/:id', keys: ['id'] });

    expect(Router.post_path())              .toEqual('/posts/:id');

    expect(Router.post_path(3))             .toEqual('/posts/3');
    expect(Router.post_path(3,  'a'))       .toEqual('/posts/3');
    expect(Router.post_path(3,  { x: 3 }))  .toEqual('/posts/3?x=3');

    expect(Router.post_path(3,  { id: 4, x: 3 })).toEqual('/posts/4?x=3');
    expect(Router.post_path(    { id: 5, x: 3 })).toEqual('/posts/5?x=3');

    Router.bindRoute('comment', { path: '/posts/:post_id/comments/:id', keys: ['post_id', 'id'] });

    expect(Router.comment_path(1))              .toEqual('/posts/1/comments/:id');
    expect(Router.comment_path(1, 2))           .toEqual('/posts/1/comments/2');
  });

  it('should handle query variables', function() {
    Router.bindRoute('post', { path: '/posts/:id', keys: ['id'] });

    expect(Router.post_path(3,  { x: [3, 4] }))   .toEqual('/posts/3?x[]=3&x[]=4');
    expect(Router.post_path(3,  { x: { y: 3 } })) .toEqual('/posts/3?x=%5Bobject%20Object%5D');
  });

  it('should handle optional parameters', function() {
    Router.bindRoute('post', { path: '/posts/:id(.:format)', keys: ['id', 'format'] });

    expect(Router.post_path()).toEqual('/posts/:id');
    expect(Router.post_path(1)).toEqual('/posts/1');
    expect(Router.post_path(2, 'xml')).toEqual('/posts/2.xml');
    expect(Router.post_path(3, {format: 'html'})).toEqual('/posts/3.html');
    expect(Router.post_path({id: 4, format: 'json'})).toEqual('/posts/4.json');
  });

  it('should handle many paramters', function() {
    Router.bindRoute('many', { path: '/:z/:b/:x/:d', keys: ['z', 'b', 'x', 'd'] });

    expect(Router.many_path(5,2,8,0)).toEqual('/5/2/8/0');
    expect(Router.many_path({z: 1, x: 3, d: 4})).toEqual('/1/:b/3/4');
  });

  describe("with jQuery", function() {
    it('should handle complex query variables', function() {

      window.expect = expect;

      (new Function( "with(this) { " + fs.readFileSync('spec/javascripts/fixtures/jquery-1.6.4.min.js').toString() + "}")).call(window);
      (new Function( "with(this) { " + fs.readFileSync('lib/templates/router.js').toString() + "}")).call(window);

      expect(window.jQuery.param).toNotEqual(null);


      with(window) {
        Router = new RouterClass({});
        Router.bindRoute('post', { path: '/posts/:id', keys: ['id'] });

        expect(Router.post_path(3,  { x: { y: 4 } })).toEqual('/posts/3?x%5By%5D=4');
        expect(Router.post_path(3,  { x: { y: "[4]" } })).toEqual('/posts/3?x%5By%5D=%5B4%5D');
      }
    });

    afterEach(function() {
      delete jQuery;
      delete $;
      delete window;
      delete document;
    });
  });

  describe("helper methods", function() {
    it('should cleanup optional parameters', function() {
      expect(Router.cleanupPath('/foo(.bar)')).toEqual('/foo.bar');
      expect(Router.cleanupPath('/foo(.:bar)')).toEqual('/foo');
    });
  });
});
