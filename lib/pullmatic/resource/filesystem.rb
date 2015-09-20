module Pullmatic
  module Resource
    class Filesystem
      def self.execute
        self.new.execute
      end

      def execute
        fs = host_inventory['filesystem']
        partitions = fs.map do |dev, spec|
          [[:name, dev], [:mount, spec["mount"]], [:size, spec["kb_size"].to_i]].to_h
        end
        puts partitions
        {:filesystem => partitions}
      end
    end
  end
end
          
