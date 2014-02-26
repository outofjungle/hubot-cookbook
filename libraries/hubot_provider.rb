require 'chef/provider'
require_relative './helpers.rb'

class Chef
  class Provider
    class HubotProvider < Chef::Provider
      def action_install
        template config_file(bot_name) do

          source 'config.rb.erb'
          mode 00600
          variables({
            :env => new_resource.env
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
            :adapter => new_resource.adapter
          })
        end
      end

      def action_enable
        run_action(:install)

        bluepill_service bot_name do
          action [:enable, :load, :start]
        end
      end

      def load_current_resource
        bluepill_resource = Chef::Resource::BluepillService.new(bot_name)
        bluepill_resource.service_name(bot_name)

        bluepill_provider = Chef::Provider::BluepillService.new(bluepill_resource, run_context)
        bluepill_provider.load_current_resource

        @current_resource = Chef::Resource::HubotResource.new(new_resource.name)
        @current_resource.enabled  = bluepill_provider.current_resource.enabled
        @current_resource.running = bluepill_provider.current_resource.running
        @current_resource.installed = bot_installed?

        @current_resource
      end

      def bot_name
        "#{new_resource.resource_name}_#{new_resource.name}_hubot"
      end

      def bot_installed?
        ::File.exists?(pill_file(bot_name))
      end
    end
  end
end
