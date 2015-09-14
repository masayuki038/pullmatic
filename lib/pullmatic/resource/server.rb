module Pullmatic
  module Resource
    class Server
      include Specinfra::Helper::Set
      def self.execute
        self.new.execute
      end

      def execute
        os_info = Specinfra.backend.os_info
        {:os_info  => os_info}
      end
    end
  end
end
