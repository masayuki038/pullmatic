module Pullmatic
  module Resource
    class UserGroup
      include Specinfra::Helper::Set
      def self.execute
        self.new.execute
      end

      def execute
        users = host_inventory['users']
        groups = host_inventory['groups']
        {:users => users, :groups => groups}
      end
    end
  end
end

class Specinfra::Command::Linux::Base::Inventory
  class << self
    def get_users
      '/bin/cat /etc/passwd'
    end

    def get_groups
      '/bin/cat /etc/group'
    end
  end
end

module Specinfra
  class HostInventory
    class Users < Base
      def get
        cmd = backend.command.get(:get_inventory_users)
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

    class Groups < Base
      def get
        cmd = backend.command.get(:get_inventory_groups)
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
