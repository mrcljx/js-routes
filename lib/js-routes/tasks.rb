namespace :js_routes do
  desc "Render routes to router.js file"
  task :draw => :environment do
    JsRoutes.build(:force)
  end
end