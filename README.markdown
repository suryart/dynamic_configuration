# dynamic_configuration

Rails made great innovations in almost all areas of web application
development, yet it surprisingly does not provide any means for
application configuration, and each of the so far available plugins I
have seen had some serious disadvantages. Here are the features that
differentiate dynamic_configuration from other configuration plugins:

 * very easy setup with only two lines of code

 * configuration files are very clean-looking Ruby files

 * in Rails development environment, one doesn't have to restart the
   server to add/remove/modify a setting

 * the settings are divided into groups, each group being defined in a
   separate file, making it easier to remember individual setting
   names and maintain the whole configuration

 * settings can be overridden locally for a given installation and
   per-Rails-environment

 * throughout field- and unit- tested

Developed as part of my work for http://www.tutoria.de/.

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
```

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

Create a subdirectory of your project directory where you want to
store the options, e. g. options/, and put the following before your
application initialization code:

```ruby
DynamicConfiguration::create(:Options, "options/")
```

## Usage

### Basics

You create a settings group by simply creating a file somewhere in the
options directory, to see how it works, create options/main.rb and
define a single setting in it:

```ruby
# config/options/main.rb
a_string "sample value"
```

This will make Options.main.a_string evaluate to "sample value"
anywhere in your application:

```ruby
Options.main.a_string
=> "sample value"
```

The name of the group of options is set to be the same as the base
name of the file, so if you create emails.rb, the settings will be
Options.emails.whatever_you_define etc.

The value of each settings can be any kind of Ruby object, so the
following is a valid config file:

```ruby
# config/options/main.rb
a_string "Some string"

an_array [1, 2, 3]

a_fancy_string_array(%w{
string1
string2
})
```

Which you can use in other places of your application like this:

```ruby
Options.main.a_string
=> "Some string"
Options.main.an_array
=> [1, 2, 3]
Options.main.a_fancy_string_array
=> ["string1", "string2"]
```

Note that hash map values have to be wrapped in parenthesis, since
defining a setting works under the hood as a Ruby method call, so it
has to have the syntax of one.

### Overriding settings per Rails environment ###

To overwrite the settings for a given Rails environment, just create a
subdirectory of the options directory, named after the name of
environment, for example config/options/test/. Then create a file
corresponding to the group of settings of which one or more you want
to override. For example, if config/options/main.rb looks like above,
and you create config/options/test/main.rb looking like this:

```ruby
# config/options/test/main.rb
a_string "Test"
```

Then Options.main.a_string will evaluate to "Test" in the test
environment, while all the other Options.main settings will evaluate
to their values defined in config/options/main.rb.

### Overriding settings of locally ###

Create a local/ subdirectory of the options directory, then create a
file corresponding to the group of settings of which one or more you
want to override, for example config/options/local/main.rb:

```ruby
# config/options/local/main.rb
an_array [4, 5, 6]
```

Then, Options.main.an_array will evaluate to [4, 5, 6] regardless of
Rails environment and other Options.main settings will be evaluated
according to their per-Rails-environment definitions if present, or
according to their global definitions in config/options/main.rb
otherwise.

## Robustness ##

dynamic_configuration overwrites method_missing in the context of the
configuration files to enable the syntax it provides. It doesn't do
anything to method_missing globally, nor does it do any other "magic"
that could affect any piece of your application other then the
configuration files themselves.

All the settings are frozen as soon as they are defined, so you won't
accidentally modify them. If you try to access a settings group that
wasn't defined, you will get an
DynamicConfiguration::MissingGroupException, if you try to access a
setting that isn't defined of a group that _is_ defined, you will get
a DynamicConfiguration::MissingGroupException.
