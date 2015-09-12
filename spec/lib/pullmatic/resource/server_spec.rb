require 'spec_helper'

module Pullmatic
  module Resource
    describe Server do
      describe ".execute" do
        it "should generate server" do
          expect(described_class.execute).to eq({:os_name => "hoge", :architecture => "x86_64"})
        end
      end
    end
  end
end
