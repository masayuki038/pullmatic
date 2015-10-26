module Pullmatic
  module Resource
    class Server
      include Specinfra::Helper::Set
      def self.execute
        self.new.execute
      end

      def execute
        os_info = Specinfra.backend.os_info
        hostname = host_inventory['hostname']
        selinux = host_inventory['selinux']
        timezone = host_inventory['timezone']
        uname = host_inventory['uname']
        {:os_info => os_info, :hostname => hostname, :selinux => selinux, :timezone => timezone, :uname => uname}
      end
    end
  end
end

class Specinfra::Command::Linux::Base::Inventory
  class << self
    def get_selinux
      Specinfra.backend.command.get(:check_selinux_has_mode, "enabled")
    end

    def get_timezone
      '/bin/cat /etc/sysconfig/clock'
    end

    def get_uname
      'uname -a'
    end
  end
end

class Specinfra::Command::Redhat::V7::Inventory < Specinfra::Command::Linux::Base::Inventory
  class << self
    def get_timezone
      "timedatectl status | grep 'Timezone' | sed -e 's/^.*Timezone: \\(.*\\)$/\\1/'"
    end
  end
end

module Specinfra
  class HostInventory
    class Selinux < Base
      def get
        cmd = backend.command.get(:get_inventory_selinux)
        ret = backend.run_command(cmd)
        if ret.exit_status == 0
          "enabled"
        else
          "disabled"
        end
      end
    end

    class Timezone < Base
      def get
        cmd = backend.command.get(:get_inventory_timezone)
        ret = backend.run_command(cmd)
        if ret.exit_status == 0
          parse(ret.stdout)
        else
          nil
        end
      end

      def parse(ret)
        ret.split("\n")[0]
      end
    end

    class Uname < Base
      def get
        cmd = backend.command.get(:get_inventory_uname)
        ret = backend.run_command(cmd)
        if ret.exit_status == 0
          ret.stdout.chomp
        else
          nil
        end
      end
    end
  end
end
