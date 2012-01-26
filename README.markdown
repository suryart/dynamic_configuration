# Application configuration made easy

Rails made great innovations in almost all areas of web application
development, yet it surprisingly does not provide any means for
application configuration, and each of the so far available plugins I
have seen had some serious disadvantages. Here are the features that
differentiate dynamic_configuration from other configuration plugins:

 * very easy setup with only two lines of code

 * configuration files are very clean-looking Ruby files

 * the configuration is automatically reloaded in Rails development environment

 * the settings are divided into groups, with each group living in a
   separate file, making it easier to remember individual setting
   names and maintain the whole configuration

 * settings can be overridden locally for a given installation and
   per-Rails-environment

 * throughout field- and unit- tested

## Setup

### Rails 3 application:

Add the gem to your Gemfile:

```ruby
gem 'dynamic_configuration'
```

Create a config/options directory, then a config/options/options.rb
file with the following contents:

```ruby
DynamicConfiguration::create(:Options, File.join(Rails.root, "config/options"))

Require config/options/options.rb somewhere in your
config/application.rb, like this:

```ruby
module SomeApplication
  class Application < Rails::Application
    require "config/options/options"
        
    # ..., rest of the config
  end
end
```

### Ruby application:

Create a directory where you want to store the options, e. g.
options/, and put the following before your application initialization
code:

```ruby
DynamicConfiguration::create(:Options, "/path/to/options")
```

## Usage
