# encoding: utf-8

require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'jeweler'

Jeweler::Tasks.new do |gem|
  gem.name = "js-routes"
  gem.summary = "Expose Rails's routes to JavaScript"
  gem.description = ""
  gem.email = "marceljackwerth@gmail.com"
  gem.homepage = "http://github.com/sirlantis/js-routes"
  gem.authors = ["Marcel Jackwerth"]
  gem.license = "MIT"
end

Jeweler::RubygemsDotOrgTasks.new

task :release => ['gemspec:release', 'git:release', 'gemcutter:release']

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
    tmp = Tempfile.new('js-routes.js')
    File.open(tmp.path, 'w') do |f|
      f.puts script
    end

    puts `jslint #{tmp.path}`
    exit_code = $?

    raise "Exited with #{exit_code}." unless exit_code == 0
  end
end