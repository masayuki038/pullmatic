module Pullmatic
  module Resource
    class Server
      include Specinfra::Helper::Set
      def self.execute
        self.new.execute
      end

      def execute
        os_info = Specinfra.backend.os_info
        se_cmd = Specinfra.backend.command.get(:check_selinux_has_mode, "enabled")
        hostname = host_inventory['hostname']
        selinux = (Specinfra.backend.run_command(se_cmd).exit_status == 0) ? "enabled" : "disabled"
        {:os_info => os_info, :hostname => hostname, :selinux => selinux}
      end
    end
  end
end
