require_relative '../spec_helper'
require_relative '../lib/dynamic_configuration'

describe DynamicConfiguration do    
  before(:each) do
    Object.instance_eval { remove_const :Settings if const_defined?(:Settings) }    
  end

  let(:path) { "#{File.dirname(__FILE__)}/options" }

  it "should create valid configurations" do
    DynamicConfiguration::create(:Settings, path)
    Settings.main.setting_one.should   == 'Some string'
    Settings.main.setting_two.should   == 123456
  end

  it "should make per-environment settings take precedence over main configuration" do
    begin
      Rails = mock(:env => 'test').as_null_object

      module ::ActiveSupport
        module Dependencies
          class << self
            def autoload_paths; []; end
            def explicitly_unloadable_constants; []; end
          end
        end
      end

      DynamicConfiguration::create(:Settings, path)
      Settings.main.setting_three.should == [3, 2, 1]
    ensure
      Object.instance_eval do
        remove_const :Rails
        remove_const :ActiveSupport
      end
    end
  end

  it "should make local settings take precedence even over per-environment settings" do
    DynamicConfiguration::create(:Settings, path)
    Settings.main.setting_four.should == 'overwrite-again'
  end

  it "should freeze the created configuration" do
    lambda {
      DynamicConfiguration::create(:Settings, path)
      Settings.main.setting_three << 4
    }.should raise_error(RuntimeError)
  end

  it "should raise an exception if trying to use a submodule that is not defined" do
    lambda {
      DynamicConfiguration::create(:Settings, path)
      Settings.xyz.setting_three
    }.should raise_error(DynamicConfiguration::MissingSubmoduleException)
  end

  it "should raise an exception if trying to use a setting that is not defined" do
    lambda {
      DynamicConfiguration::create(:Settings, path)
      Settings.main.xyz
    }.should raise_error(DynamicConfiguration::MissingSettingException)
  end
end
