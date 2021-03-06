require 'test_helper'

module Slingshot

  class ConfigurationTest < Test::Unit::TestCase

    context "Configuration" do
      setup do
        Configuration.instance_variable_set(:@url,    nil)
        Configuration.instance_variable_set(:@client, nil)
      end

      should "return default URL" do
        assert_equal 'http://localhost:9200', Configuration.url
      end

      should "allow setting and retrieving the URL" do
        assert_nothing_raised { Configuration.url 'http://example.com' }
        assert_equal 'http://example.com', Configuration.url
      end

      should "return default client" do
        assert_equal Client::RestClient, Configuration.client
      end

      should "allow setting and retrieving the client" do
        assert_nothing_raised { Configuration.client Client::Base }
        assert_equal Client::Base, Configuration.client
      end

      should "allow to reset the configuration for specific property" do
        Configuration.url 'http://example.com'
        Configuration.client Client::Base
        assert_equal 'http://example.com', Configuration.url
        Configuration.reset :url
        assert_equal 'http://localhost:9200', Configuration.url
        assert_equal Client::Base, Configuration.client
      end

      should "allow to reset the configuration for all properties" do
        Configuration.url 'http://example.com'
        Configuration.client Client::Base
        assert_equal 'http://example.com', Configuration.url
        assert_equal Client::Base, Configuration.client
        Configuration.reset
        assert_equal 'http://localhost:9200', Configuration.url
        assert_equal Client::RestClient, Configuration.client
      end
    end

  end

end
