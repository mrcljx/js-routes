JSRoutes
=
JSRoutes will convert *named* Rails routes to a JavaScript object. It has one method, copy_routes, that should be used when your app boots up, AFTER routes have been loaded.

JSRoutes is completely untested beyond development in Safari. Neither the Ruby nor the JavaScript is currently guaranteed to work. It will, someday. Just not today.

Installation
-
In your RAILS_ROOT, run:

`ruby script/plugin install git://github.com/flipsasser/js-routes.git`

Usage
-
Add an initializer in config/initializers named routes.rb. Call `JSRoutes.copy_routes` from that initializer.

`copy_routes` accepts a hash of options, all optional:

	:global - String; the name to give the router object in JavaScript. Defaults to 'Router'
	:minify - Boolean; whether or not to minify the JavaScript getting written. Defaults to 'true' when Rails is in production
	:filename - String; the filename for the router JavaScript file to write do. Defaults to 'router.js'
	:path - String; the path (relative to RAILS_ROOT/public) to store the files in. Defaults to 'javascripts'
	:append - String; the file path (relative to RAILS_ROOT/public) to append the Router JS to. This allows users to append the Router to any of their existing JavaScript files.

Example
-

Ruby (in your initializer):

	JSRoutes.copy_routes # Create public/javascripts/router.js and name the JS object 'Router'. Be sure to add javascript_include_tag(:router) if you do this!
	JSRoutes.copy_routes(:append => 'javascripts/application.js') # Append the Router object to public/javascripts/application.js
	JSRoutes.copy_routes(:global => 'RailsRouter') # Create a file with JS object named 'RailsRouter'
	JSRoutes.copy_routes(:path => 'js/lib') # Create public/js/lib/router.js
	JSRoutes.copy_routes(:path => 'js/lib', :filename => 'rails_routes.js') # Create public/js/lib/rails_routes.js

The resulting JavaScript object (by default named 'Router') is accessible as an application global. It responds to any named_route your router builds. For example, with the following route:

	map.contact 'contact/:id', :controller => 'main', :action => 'contact', :method => :get

... the JavaScript object responds to the following methods:

	Router.contact(); # Absolute path to the contact resource. I know, I know, this isn't the Rails Way&tm;, but come *on*...
	Router.contact_path(); # Alias for the above
	Router.contact_url(); # URL for the contact resource ('http://localhost:3000/contact')
	Router.contact({id: 1}) # Path to 'contact/1'

The JavaScript router also handles some segment validations, just like the Rails router. For example, using the given route:

	map.market_quote 'quote/:state/:city', :controller => 'main', :action => 'quote', :requirements => {:city => /[A-Za-z0-9\+\.-]+/, :state => /[A-Z]{2,4}/}

... the JavaScript object will throw errors unless an appropriate city and state are passed into the method. Example:

	Router.market_quote_path({city: 'Baltimore', state: 'MD'}) #=> '/quote/MD/Baltimore'
	Router.market_quote_path({city: 'Baltimore', state: 'foo'}) #=> Exception: '`state` (foo) does not match requirements: /[A-Z]{2,3}/'

I'll be adding full Router support at some point, and possibly MooTools, Prototype, and/or jQuery AJAX integration (e.g. `Router.post_market_quote_path({options: whatever}, {data: 'values'}, callback)`)

Copyright (c) 2009 Flip Sasser, released under the MIT license