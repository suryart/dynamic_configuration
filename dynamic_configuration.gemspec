# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dynamic_configuration}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Jarosław Rzeszótko}]
  s.date = %q{2012-01-26}
  s.description = %q{Flexible configuration library for Ruby and Rails applications.}
  s.email = %q{jrzeszotko@gmail.com}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    "README.markdown",
    "Rakefile",
    "VERSION",
    "dynamic_configuration.gemspec",
    "lib/dynamic_configuration.rb",
    "spec/dynamic_configuration_spec.rb",
    "spec/options/local/main.rb",
    "spec/options/main.rb",
    "spec/options/production/main.rb",
    "spec/options/test/main.rb",
    "spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/jaroslawr/dynamic_configuration}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Flexible configuration library for Ruby and Rails applications.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<builder>, [">= 0"])
    else
      s.add_dependency(%q<builder>, [">= 0"])
    end
  else
    s.add_dependency(%q<builder>, [">= 0"])
  end
end

