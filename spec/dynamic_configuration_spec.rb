require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'lib/dynamic_configuration/dynamic_configuration'

describe DynamicConfiguration do
  before(:each) do
    Object.instance_eval { remove_const :Settings if const_defined?(:Settings) } 
  end  

  it "should create valid configurations" do
    DynamicConfiguration::create(:Settings, "#{Rails.root}/lib/dynamic_configuration/spec/options/options.rb")

    Settings.main.setting_one.should   == 'Some string'
    Settings.main.setting_two.should   == 123456
  end

  it "should make per-environment settings take precedence over main configuration" do
    DynamicConfiguration::create(:Settings, "#{Rails.root}/lib/dynamic_configuration/spec/options/options.rb")

    Settings.main.setting_three.should == [3, 2, 1]
  end

  it "should make local settings take precedence even over per-environment settings" do
    DynamicConfiguration::create(:Settings, "#{Rails.root}/lib/dynamic_configuration/spec/options/options.rb")

    Settings.main.setting_four.should == 'overwrite-again'
  end
end
