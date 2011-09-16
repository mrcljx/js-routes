JsRoutes
=
JsRoutes will enable you to use *named* Rails routes in JavaScript.

Installation
-
Add the gem requirement to your GEMFILE

  gem 'js-routes', :git => 'git://github.com/sirlantis/js-routes.git'

I recommend that you also specify a `:tag` to prevent incompatibilties.

Configuration
-
Configuration is done in the `application.rb` of your Rails 3 app - accessible via `config.jsroutes`. The available options and their defaults:

    # How the JavaScript object will be named
    config.js_routes.global  = "Router"

    # Should the JS file be minified?
    config.js_routes.minify  = Rails.env.production?

    # Where should the file be stored / be accessed at.
    config.js_routes.path    = 'javascripts/router.js'

    # Should JsRoutes be mounted as a **middleware** (development, Heroku) or write the file once at boot-time (production)?
    # There is also a :write option which can cause issues if more instances are booted (cluster/mod_passenger).
    config.js_routes.mode    = Rails.env.production? ? :write_once : :mount

Examples
-

### Routes
    get :signup, :as => :signup

    resources :posts do
      resources :comments
    end

### Views

    Router.signup_path()
    > /signup

    Router.signup_url()
    > http://yourwebsite.com:3000/signup

    Router.posts_path()
    > /posts

    Router.post_path(3)
    > /posts/3

    # nested resources
    Router.post_comment_path(3, 4)
    > /posts/3/comments/4

    # named params, all same output
    Router.post_path(3, "xml")
    Router.post_path(3, {format: "xml"})
    Router.post_path({id: 3, format: "xml"})
    > /posts/3.xml

    # additional params
    Router.post_path({id: 3, format: "xml", foo: "bar"})
    > /posts/3.xml?foo=bar

Compatibility
-
The way JsRoutes is built it should be able to handle all of Rails options for Routes (optional params etc.).

Intellectual Property
-
Copyright (c) 2010 Marcel Jackwerth (inspired by Flip Sasser), released under the MIT license