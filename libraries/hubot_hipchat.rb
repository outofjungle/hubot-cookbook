require_relative 'hubot_provider'
require_relative 'hubot_resource'
require_relative './helpers.rb'

class Chef
  class Resource
    class HubotHipchat < Chef::Resource::HubotResource
      self.resource_name = 'hubot_hipchat'

      attribute :jabber_id, :kind_of => String, :required => true
      attribute :password, :kind_of => String, :required => true
    end
  end
end

class Chef
  class Provider
    class HubotHipchat < Chef::Provider::HubotProvider
      setup_actions
    end
  end
end
