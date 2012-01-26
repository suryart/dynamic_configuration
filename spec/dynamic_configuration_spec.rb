require_relative '../spec_helper'
require_relative '../dynamic_configuration'

describe DynamicConfiguration do
  let(:path) { "#{File.dirname(__FILE__)}/options" }
  
  before(:each) do
    Object.instance_eval { remove_const :Settings if const_defined?(:Settings) } 
  end  

  it "should create valid configurations" do
    DynamicConfiguration::create(:Settings, path)

    Settings.main.setting_one.should   == 'Some string'
    Settings.main.setting_two.should   == 123456
  end

  it "should make per-environment settings take precedence over main configuration" do
    Rails = mock(:env => 'test')

    DynamicConfiguration::create(:Settings, path)

    Settings.main.setting_three.should == [3, 2, 1]

    Object.instance_eval { remove_const :Rails }
  end

  it "should make local settings take precedence even over per-environment settings" do
    DynamicConfiguration::create(:Settings, path)

    Settings.main.setting_four.should == 'overwrite-again'
  end
end
