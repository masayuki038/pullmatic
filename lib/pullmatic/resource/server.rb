module Pullmatic
  module Resource
    class Server
      def self.execute
        self.new.execute
      end
      
      def execute
        {:os_name => "hoge", :architecture => "x86_64"}
      end
    end
  end
end
