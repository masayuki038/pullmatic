module Pullmatic
  module Resource
    class Filesystem
      def self.execute
        self.new.execute
      end

      def execute
        fs = host_inventory['filesystem']
        partitions = fs.map do |dev, spec|
          [[:name, dev], [:mount, spec["mount"]], [:type, spec["type"]], [:kb_size, spec["kb_size"].to_i], [:kb_used, spec["kb_used"].to_i], [:kb_available, spec["kb_available"].to_i], [:percent_used, spec["percent_used"]], [:mount, spec["mount"]]].to_h
        end
        partitions
      end
    end
  end
end

class Specinfra::Command::Linux::Base::Inventory
  class << self
    def get_filesystem
      'df -T'
    end
  end
end

module Specinfra
  class HostInventory
    class Filesystem
      def parse(ret)
        filesystem = {}
        ret.each_line do |line|
          next if line =~ /^Filesystem\s+/
          if line =~ /^(.+?)\s+(\w+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+\%)\s+(.+)$/
            device = $1
            filesystem[device] = {}
            filesystem[device]['type'] = $2
            filesystem[device]['kb_size'] = $3
            filesystem[device]['kb_used'] = $4
            filesystem[device]['kb_available'] = $5
            filesystem[device]['percent_used'] = $6
            filesystem[device]['mount'] = $7
          end
        end
        filesystem
      end
    end
  end
end
