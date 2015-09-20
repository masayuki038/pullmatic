require 'spec_helper'

module Pullmatic
  module Resource
    describe Server do
      describe ".execute" do
        it "should generate server" do
          expect(described_class.execute).to eq({:server => {:os_info => {:family => "ubuntu",
                                                                         :release => "14.04",
                                                                         :arch => "x86_64"},
                                                    :hostname => "a3b6ee4e9425",
                                                    :selinux => "disabled"}})
        end
      end
    end
  end
end
