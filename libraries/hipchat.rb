require 'chef/resource/lwrp_base'
require 'chef/provider/lwrp_base'
require_relative './helpers.rb'

class Chef
  class Resource
    class Hipchat < Chef::Resource::LWRPBase
      self.resource_name = 'hipchat'

      actions :enable, :install
      default_action :enable
      state_attrs :enabled, :installed

      attribute :bot_name, :kind_of => String, :name_attribute => true
      attribute :jabber_id, :kind_of => String, :required => true
      attribute :password, :kind_of => String, :required => true
    end
  end
end

class Chef
  class Provider
    class Hipchat < Chef::Provider::LWRPBase

      action :install do
        config_file = "/etc/hubot/#{bot_name}_config.rb"
        pill_file = "/etc/bluepill/#{bot_name}.pill"
        log_file = "/var/log/hubot/#{bot_name}.log"

        template config_file do
          source 'config.rb.erb'
          mode 00600
          variables({
            :jabber_id => new_resource.jabber_id,
            :password => new_resource.password
          })
        end

        file log_file do
          user hubot_user
          group hubot_group
          mode 00644
        end

        template pill_file do
          source 'hubot.pill.erb'
          mode 00644
          variables({
            :config_file => config_file,
            :bot_name => bot_name
          })
        end
      end

      action :enable do
        run_action(:install)

        bluepill_service "#{bot_name}" do
          action [:enable, :load, :start]
        end
      end

      def bot_name
        "#{Chef::Resource::Hipchat.resource_name}_#{new_resource.name}_hubot"
      end
    end
  end
end
