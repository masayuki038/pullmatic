module Pullmatic
  module Resource
    class Etc
      include Specinfra::Helper::Set
      def self.execute
        self.new.execute
      end

      def execute
        sshd_config = host_inventory['sshd_config']
        services = host_inventory['services']
        {:sshd_config => sshd_config, :services => services}
      end
    end
  end
end

class Specinfra::Command::Linux::Base::Inventory
  class << self
    def get_sshd_config
      '/bin/cat /etc/ssh/sshd_config'
    end

    def get_services
      '/usr/sbin/service --status-all'
    end
  end
end

class Specinfra::Command::Redhat::V7::Inventory < Specinfra::Command::Linux::Base::Inventory
  class << self
    def get_services
      '/usr/bin/systemctl list-units --type=service | /bin/grep -e "\.service"'
    end
  end
end

module Specinfra
  class HostInventory
    class SshdConfig < Base
      def get
        cmd = backend.command.get(:get_inventory_sshd_config)
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
          entries << l if l =~ /^[^#]/
        end
        entries
      end
    end

    class Services < Base
      def get
        cmd = backend.command.get(:get_inventory_services)
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
