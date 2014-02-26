require_relative 'hubot_provider'
require_relative 'hubot_resource'
require_relative './helpers.rb'

class Chef
  class Resource
    class HubotHipchat < Chef::Resource::HubotResource
      def initialize(name, run_context=nil)
        super
        @resource_name = :hubot_hipchat
        @provider = Chef::Provider::HubotHipchat
        @adapter = 'hipchat'
      end
    end
  end
end

class Chef
  class Provider
    class HubotHipchat < Chef::Provider::HubotProvider
    end
  end
end
