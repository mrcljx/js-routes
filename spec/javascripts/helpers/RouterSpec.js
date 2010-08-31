describe("Router", function() {
  it("should generate named routes", function() {
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
  
  it('should handle optional parameters', function() {
    Router.bindRoute('post', { path: '/posts/:id(.:format)', keys: ['id', 'format'] });
    
    expect(Router.post_path()).toEqual('/posts/:id');
    expect(Router.post_path(1)).toEqual('/posts/1');
    expect(Router.post_path(2, 'xml')).toEqual('/posts/2.xml');
    expect(Router.post_path(3, {format: 'html'})).toEqual('/posts/3.html');
    expect(Router.post_path({id: 4, format: 'json'})).toEqual('/posts/4.json');
  });
  
  describe("helper methods", function() {
    it('should cleanup optional parameters', function() {
      expect(Router.cleanupPath('/foo(.bar)')).toEqual('/foo.bar');
      expect(Router.cleanupPath('/foo(.:bar)')).toEqual('/foo');
    });
  });
});
