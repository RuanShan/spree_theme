require 'spec_helper'
describe Spree::ThemeConfiguration, "#website_class" do
  let (:config) { SpreeTheme::Config }
    it "has website class" do

    expect(config.website_class).to be_a_kind_of(Class)
    expect(config.website_class.current).to be_an_instance_of(Spree::ThemeConfiguration::FakeWebsite)
  end
end