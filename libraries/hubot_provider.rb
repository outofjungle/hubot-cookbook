require 'chef/provider/lwrp_base'
require_relative './helpers.rb'

class Chef
  class Provider
    class HubotProvider < Chef::Provider::LWRPBase

      use_inline_resources

      def self.setup_actions
        action :install do
          template config_file(bot_name) do
            source 'config.rb.erb'
            mode 00600
            variables({
              :jabber_id => new_resource.jabber_id,
              :password => new_resource.password
            })
          end

          file log_file(bot_name) do
            user hubot_user
            group hubot_group
            mode 00644
          end

          template pill_file(bot_name) do
            source 'hubot.pill.erb'
            mode 00644
            variables({
              :config_file => config_file(bot_name),
              :bot_name => bot_name,
              :adapter => 'hubot'
            })
          end
        end

        action :enable do
          run_action(:install)

          bluepill_service bot_name do
            action [:enable, :load, :start]
          end
        end
      end

      def load_current_resource
        bluepill_resource = Chef::Resource::BluepillService.new(bot_name)
        bluepill_resource.service_name(bot_name)

        bluepill_provider = Chef::Provider::BluepillService.new(bluepill_resource, run_context)
        bluepill_provider.load_current_resource

        @current_resource = Chef::Resource::HubotHipchat.new(new_resource.name)
        @current_resource.enabled = bluepill_provider.current_resource.enabled
        @current_resource.running = bluepill_provider.current_resource.running
        @current_resource.installed = bot_installed?

        @current_resource
      end

      def bot_name
        "#{Chef::Resource::HubotHipchat.resource_name}_#{new_resource.name}_hubot"
      end

      def bot_installed?
        ::File.exists?(pill_file(bot_name))
      end
    end
  end
end
