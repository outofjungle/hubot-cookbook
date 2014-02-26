require 'chef/resource'

class Chef
  class Resource
    class HubotResource < Chef::Resource
      def initialize(name, run_context=nil)
        super
        @action = :enable
        @allowed_actions = [:install, :enable]
        @name = name
      end

      def env(arg=nil)
        set_or_return(:env, arg, :kind_of => [Hash])
      end

      attr_accessor :enabled, :installed, :running, :adapter
    end
  end
end
