# -*- coding: utf-8 -*-

require 'rake'
require 'jeweler'
require 'rspec/core/rake_task'

desc 'Default: Run all specs for a specific rails version.'
task :default => :spec

desc "Run all specs for a specific rails version"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = '**/*_spec.rb'
end

Jeweler::Tasks.new do |gem|
  gem.name = "dynamic_configuration"
  gem.summary = "Flexible configuration library for Ruby and Rails applications."
  gem.description = "Flexible configuration library for Ruby and Rails applications."
  gem.email = "jrzeszotko@gmail.com"
  gem.homepage = "http://github.com/jaroslawr/dynamic_configuration"
  gem.authors = ["Jarosław Rzeszótko"]
end

Jeweler::RubygemsDotOrgTasks.new
