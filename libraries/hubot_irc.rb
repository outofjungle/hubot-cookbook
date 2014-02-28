require_relative 'hubot_provider'
require_relative 'hubot_resource'
require_relative './helpers.rb'

class Chef
  class Resource
    class HubotIrc < Chef::Resource::HubotResource
      def initialize(name, run_context=nil)
        super
        @resource_name = :hubot_irc
        @provider = Chef::Provider::HubotIrc
        @adapter = 'irc'
      end
    end
  end
end

class Chef
  class Provider
    class HubotIrc < Chef::Provider::HubotProvider
    end
  end
end
