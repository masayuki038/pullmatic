require 'spec_helper'

module Pullmatic
  module Resource
    describe Etc do
      before do
        property[:host_inventory] = {}
      end

      describe ".execute" do
        it "should generate about sshd_config" do
          ret = described_class.execute
          expect(ret.keys).to include(:sshd_config)
          expect(ret[:sshd_config].size).to eq(4)
          expect(ret[:sshd_config][0]).to eq("X11Forwarding yes")
          expect(ret[:sshd_config][1]).to eq("PrintMotd no")
          expect(ret[:sshd_config][2]).to eq("PrintLastLog yes")
          expect(ret[:sshd_config][3]).to eq("TCPKeepAlive yes")
        end
        before do
          allow(Specinfra::Command::Linux::Base::Inventory).to receive(:get_sshd_config).and_return(
<<EOF
cat << EOF2
X11Forwarding yes
#X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
EOF2
EOF
)       end
      end
    end
  end
end
