module Pullmatic
  module Resource
    class Interface
      def self.execute
        self.new.execute
      end

      def execute
        ip = host_inventory['ip']
        default_gateway = host_inventory['default_gateway']
        {:ip => ip, :default_gateway => default_gateway}
      end
    end
  end
end

class Specinfra::Command::Linux::Base::Inventory
  class << self
    def get_ip
      '/sbin/ip addr'
    end

    def get_default_gateway
      '/sbin/ip route'
    end
  end
end

module Specinfra
  class HostInventory
    class Ip < Base
      def get
        cmd = backend.command.get(:get_inventory_ip)
        ret = backend.run_command(cmd)
        if ret.exit_status == 0
          parse(ret.stdout)
        else
          nil
        end
      end

      def parse(ret)
        ifs = {}
        name = ipv4 = ipv6 = nil
        ret.split("\n").each do |l|
          name = $2 if l =~ /^(\d+):\s(\w+):/
          ipv4 = $1 if l =~ /^\s+inet\s([0-9.\/]+)/
          ipv6 = $1 if l =~ /^\s+inet6\s([0-9a-f:.\/]+)/
          ifs[name] = {:ipv4 => ipv4, :ipv6 => ipv6}
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
        ret.split("\n")
      end
    end
  end
end
