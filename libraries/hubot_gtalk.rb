require_relative 'hubot_provider'
require_relative 'hubot_resource'
require_relative './helpers.rb'

class Chef
  class Resource
    class HubotGtalk < Chef::Resource::HubotResource
      def initialize(name, run_context=nil)
        super
        @resource_name = :hubot_gtalk
        @provider = Chef::Provider::HubotGtalk
        @adapter = 'gtalk-gluck'
      end
    end
  end
end

class Chef
  class Provider
    class HubotGtalk < Chef::Provider::HubotProvider
    end
  end
end
