namespace :jsroutes do
  desc "Render routes to router.js file"
  task :draw => :environment do
    JSRoutes.build(:force)
  end
end