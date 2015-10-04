module Pullmatic
  module Resource
    class Network
      def self.execute
        self.new.execute
      end

      def execute
        hosts = host_inventory['hosts']
        default_gateway = host_inventory['default_gateway']
        iptables = host_inventory['iptables']
      end
    end
  end
end

class Specinfra::Command::Linux::Base::Inventory
  class << self
    def get_hosts
      '/bin/cat /etc/hosts'
    end

    def get_default_gateway
      '/sbin/ip route'
    end

    def get_iptables
      '/sbin/iptables'
    end
  end
end

module Specinfra
  class HostInventory
    class Hosts < Base
      def get
        cmd = backend.command.get(:get_inventory_hosts)
        ret = backend.run_command(cmd)
        if ret.exit_status == 0
          parse(ret.stdout)
        else
          nil
        end
      end

      def parse(ret)
        entries = []
        ret.split("\n").each do |l|
          entries << l if l =~ /^[^#]+/ 
        end
        ifs
      end
    end
    
    class DefaultGateway < Base
      def get
        cmd = backend.command.get(:get_inventory_default_gateway)
        ret = backend.run_command(cmd)
        if ret.exit_status == 0
          parse(ret.stdout)
        else
          nil
        end
      end

      def parse(ret)
        ret.split("\n").each do |l|
          return l if  l =~ /^default/
        end
        nil
      end
    end
  end
end

