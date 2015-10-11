module Pullmatic
  module Resource
    class Interface
      def self.execute
        self.new.execute
      end

      def execute
        ifs = host_inventory['interface']
        {:interface => ifs}
      end
    end
  end
end

class Specinfra::Command::Linux::Base::Inventory
  class << self
    def get_interface
      '/sbin/ip addr'
    end
  end
end

module Specinfra
  class HostInventory
    class Interface < Base
      def get
        cmd = backend.command.get(:get_inventory_interface)
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
  end
end
