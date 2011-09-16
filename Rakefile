require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "jsroutes"
    gemspec.summary = "Expose Rails's routes to JavaScript"
    gemspec.description = ""
    gemspec.email = "marceljackwerth@gmail.com"
    gemspec.homepage = "http://github.com/sirlantis/jsroutes"
    gemspec.authors = ["Marcel Jackwerth"]
    gemspec.add_development_dependency('jsmin', '>= 1.0.1')
    gemspec.add_development_dependency('jasmine', '>= 1.1.0')
    gemspec.add_development_dependency('rails', '>= 3.0.0')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end

task :default => :ci

desc "Runs all relevant tasks to check healthiness of this gem"
task :ci do
  results = ["spec:js", "lint:js"].collect do |task_name|
    task = Rake::Task[task_name]

    error = nil

    begin
      task.execute
    rescue => e
      error = e
    end

    [task_name, error]
  end

  fails = results.select { |result| result[1] }

  unless fails.empty?
    fails.each do |fail|
      puts "[#{fail[0]}] #{fail[1].message}"
    end
  end

  exit(fails.count)
end

namespace :spec do
  desc "Runs the specs for JavaScript files"
  task :js do
    puts `node specs.js $@`
    exit_code = $?

    raise "Exited with #{exit_code}." unless exit_code == 0
  end
end

namespace :lint do
  desc "Runs JSLint for JavaScript files"
  task :js do
    `which jslint`

    unless $? == 0
      puts "JSLint command-line tool required."
      puts "Install via 'npm install jslint' (v0.1.1+) for correct error reporting."
      return 0
    end

    require "active_support/core_ext/object"

    template_file = File.join(File.dirname(__FILE__), 'lib', 'templates', 'router.js')
    template = IO.read(template_file)

    global = "Router"
    converted_routes = {}

    script = "" << template << global << " = " << "new RouterClass(" << converted_routes.to_json << ");"

    # require 'jsmin'
    # script = JSMin.minify(script)

    require 'tempfile'
    tmp = Tempfile.new('jsroutes.js')
    File.open(tmp.path, 'w') do |f|
      f.puts script
    end

    puts `jslint #{tmp.path}`
    exit_code = $?

    raise "Exited with #{exit_code}." unless exit_code == 0
  end
end