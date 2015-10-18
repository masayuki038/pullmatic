require 'spec_helper'

module Pullmatic
  module Resource
    describe UserGroup do
      before do
        property[:host_inventory] = {}
      end

      describe ".execute" do
        it "should generate about users" do
          ret = described_class.execute
          expect(ret.keys).to include(:users)
          expect(ret[:users].size).to eq(3)
          expect(ret[:users][0]).to eq("masayuki:x:1000:1000:Masayuki Takahashi,,,:/home/masayuki:/bin/bash")
          expect(ret[:users][1]).to eq("lxc-dnsmasq:x:104:110:LXC dnsmasq,,,:/var/lib/lxc:/bin/false")
          expect(ret[:users][2]).to eq("redis:x:105:111:redis server,,,:/var/lib/redis:/bin/false")
        end
        before do
          allow(Specinfra::Command::Linux::Base::Inventory).to receive(:get_users).and_return(
<<EOF
cat << EOF2
masayuki:x:1000:1000:Masayuki Takahashi,,,:/home/masayuki:/bin/bash
lxc-dnsmasq:x:104:110:LXC dnsmasq,,,:/var/lib/lxc:/bin/false
redis:x:105:111:redis server,,,:/var/lib/redis:/bin/false
EOF2
EOF
)       end
      end

      describe ".execute" do
        it "should generate about groups" do
          ret = described_class.execute
          expect(ret.keys).to include(:groups)
          expect(ret[:groups].size).to eq(3)
          expect(ret[:groups][0]).to eq("lxc-dnsmasq:x:110:")
          expect(ret[:groups][1]).to eq("redis:x:111:")
          expect(ret[:groups][2]).to eq("docker:x:999:")
        end
        before do
          allow(Specinfra::Command::Linux::Base::Inventory).to receive(:get_groups).and_return(
<<EOF
cat << EOF2
lxc-dnsmasq:x:110:
redis:x:111:
docker:x:999:
EOF2
EOF
)       end
      end
    end
  end
end

