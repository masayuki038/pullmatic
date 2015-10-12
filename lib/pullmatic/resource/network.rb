module Pullmatic
  module Resource
    class Network
      def self.execute
        self.new.execute
      end

      def execute
        hosts = host_inventory['hosts']
        default_gateway = host_inventory['default_gateway']
        filter = host_inventory['iptables_filter']
        nat = host_inventory['iptables_nat']
        {:hosts => hosts, :default_gateway => default_gateway, :iptables => {:filter => filter, :nat => nat}}
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

    def get_iptables_filter
      '/sbin/iptables -L'
    end

    def get_iptables_nat
      '/sbin/iptables -t nat -L'
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
        entries
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
        entries = []
        ret.split("\n").each do |l|
          entries << l if  l =~ /^default/
        end
        entries
      end
    end

    class IptablesBase < Base
      def parse(ret)
        entries = {}
        chain = nil
        ret.each_line do |l|
          case l
          when /^Chain INPUT/
            chain = :input
          when /^Chain FORWARD/
            chain = :forward
          when /^Chain OUTPUT/
            chain = :output
          when /^Chain PREROUTING/
            chain = :prerouting
          when /^Chain POSTROUTING/
            chain = :postrouting
          end
          entries[chain] ||= ""
          entries[chain] << l
        end
        entries
      end
    end

    class IptablesFilter < IptablesBase
      def get
        cmd = backend.command.get(:get_inventory_iptables_filter)
        ret = backend.run_command(cmd)
        if ret.exit_status == 0
          parse(ret.stdout)
        else
          nil
        end
      end
    end

    class IptablesNat < IptablesBase
      def get
        cmd = backend.command.get(:get_inventory_iptables_nat)
        ret = backend.run_command(cmd)
        if ret.exit_status == 0
          parse(ret.stdout)
        else
          nil
        end
      end
    end
  end
end

