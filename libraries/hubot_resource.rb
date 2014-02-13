require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class HubotResource < Chef::Resource::LWRPBase

      attribute :name, :kind_of => String, :name_attribute => true
      attribute :enabled, :kind_of => [TrueClass, FalseClass, NilClass], :default => false
      attribute :installed, :kind_of => [TrueClass, FalseClass, NilClass], :default => false

      attr_accessor :enabled, :installed, :running
    end
  end
end
