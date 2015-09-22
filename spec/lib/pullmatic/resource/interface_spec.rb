require 'spec_helper'

module Pullmatic
  module Resource
    describe Interface do
      describe ".execute" do
        it "should generate interface" do
          ret = described_class.execute
          puts "ret: #{ret.inspect}"
          expect(ret.keys).to include(:interface)
          expect(ret[:interface].keys).to include("lo")
        end
      end
    end
  end
end
