JSRoutes
=
JSRoutes will convert *named* Rails routes to a JavaScript object. It uses an enable method that should be called when your app boots up.

JSRoutes is completely untested beyond development in Safari. Neither the Ruby nor the JavaScript is currently guaranteed to work. It will, someday. Just not today.

Installation
-
In your RAILS_ROOT, run:

`ruby script/plugin install git://github.com/flipsasser/js-routes.git`

Usage
-
Add an initializer in config/initializers named routes.rb. Call `JSRoutes.enable` from that initializer.

`enable` accepts a hash of options, all optional:

	:global - String; the name to give the router object in JavaScript. Defaults to 'Router'
	:minify - Boolean; whether or not to minify the JavaScript getting written. Defaults to 'true' when Rails is in production
	:path - String; the file path (relative to RAILS_ROOT/public) in which to store the Router code. Defaults to '/javascripts/router.js'
	:append - Boolean; whether or not to append the routing code to the bottom of an existing JavaScript file.

Example
-

Ruby (in your initializer):

	JSRoutes.enable # Store routes in public/javascripts/router.js and create the JS object 'Router'. Be sure to add javascript_include_tag(:router) if you do this!
	JSRoutes.enable(:append => 'javascripts/application.js') # Append the Router object to public/javascripts/application.js
	JSRoutes.enable(:global => 'RailsRouter') # Store routes with a JS object named 'RailsRouter'
	JSRoutes.enable(:path => 'js/lib/foobar.js') # Store routes in public/js/lib/foobar.js

The resulting JavaScript object (by default named 'Router') is accessible as an application global. It responds to any named_route your router builds. For example, with the following route:

	map.contact 'contact/:id', :controller => 'main', :action => 'contact', :method => :get

... the JavaScript object responds to the following methods:

	Router.contact(); # Absolute path to the contact resource. I know, I know, this isn't the Rails Way, but come *on*...
	Router.contact_path(); # Alias for the above
	Router.contact_url(); # Full URL for the path contact resource ('http://localhost:3000/contact')
	Router.contact({id: 1}) # Path to 'contact/1'

The JavaScript router also handles some segment validations, just like the Rails router. For example, using the given route:

	map.market_quote 'quote/:state/:city', :controller => 'main', :action => 'quote', :requirements => {:city => /[A-Za-z0-9\+\.-]+/, :state => /[A-Z]{2,4}/}

... the JavaScript object will throw errors unless an appropriate city and state are passed into the method. Example:

	Router.market_quote_path({city: 'Baltimore', state: 'MD'}) #=> '/quote/MD/Baltimore'
	Router.market_quote_path({city: 'Baltimore', state: 'foo'}) #=> Exception: '`state` (foo) does not match requirements: /[A-Z]{2,3}/'

I'll be adding full Router support at some point, and possibly MooTools, Prototype, and/or jQuery AJAX integration (e.g. `Router.post_market_quote_path({options: whatever}, {data: 'values'}, callback)`)

Copyright (c) 2009 Flip Sasser, released under the MIT license