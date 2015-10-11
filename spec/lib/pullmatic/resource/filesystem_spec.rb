require 'spec_helper'

module Pullmatic
  module Resource
    describe Filesystem do
      describe ".execute" do
        it "should generate filesystem" do
          ret = described_class.execute
          expect(ret.keys).to include(:filesystem)
          expect(ret[:filesystem].size).to eq(3)
          expect(ret[:filesystem][0][:name]).to eq('/dev/xvda1')
          expect(ret[:filesystem][0][:type]).to eq('ext4')
          expect(ret[:filesystem][0][:kb_size]).to eq(10189112)
          expect(ret[:filesystem][0][:kb_used]).to eq(6969052)
          expect(ret[:filesystem][0][:kb_available]).to eq(2695828)
          expect(ret[:filesystem][0][:percent_used]).to eq('73%')
          expect(ret[:filesystem][0][:mount]).to eq('/')
        end
      end
      before do
        allow(Specinfra::Command::Linux::Base::Inventory).to receive(:get_filesystem).and_return(
<<EOF
cat << EOF2
Filesystem     Type  1K-blocks     Used Available Use% Mounted on
/dev/xvda1     ext4   10189112  6969052   2695828  73% /
tmpfs          tmpfs   1864572        0   1864572   0% /dev/shm
/dev/xvdb      ext4   30832636 20297956   8961816  70% /var/project
EOF2
EOF
)
      end
    end
  end
end
