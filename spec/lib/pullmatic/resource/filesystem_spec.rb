require 'spec_helper'

module Pullmatic
  module Resource
    describe Filesystem do
      describe ".execute" do
        it "should generate filesystem" do
          ret = described_class.execute
          expect(ret.keys).to include(:filesystem)
        end
      end
    end
  end
end
