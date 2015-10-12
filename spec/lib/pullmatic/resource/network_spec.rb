require 'spec_helper'

module Pullmatic
  module Resource
    describe Network do
      describe "hosts" do
        it "should generate about hosts" do
          ret = described_class.execute
          expect(ret.keys).to include(:hosts)
          expect(ret[:hosts].size).to eq(3)
          expect(ret[:hosts]).to include("127.0.0.1 localhost.localdomain localhost")
          expect(ret[:hosts]).to include("192.168.1.20 test2")
          expect(ret[:hosts]).not_to include("# 192.168.0.1 comment")
        end
      end
      before do
        allow(Specinfra::Command::Linux::Base::Inventory).to receive(:get_hosts).and_return(
<<EOF
cat << EOF2
# 192.168.0.1 comment
#192.168.0.2 comment2
127.0.0.1 localhost.localdomain localhost
192.168.1.10 test1
192.168.1.20 test2
EOF2
EOF
)
      end

      describe "default_gateway" do
        it "should generate about default gateway" do
          ret = described_class.execute
          expect(ret.keys).to include(:default_gateway)
          expect(ret[:default_gateway].size).to eq(2)
          expect(ret[:default_gateway][0]).to eq("default via 172.17.42.1 dev eth0")
          expect(ret[:default_gateway][1]).to eq("default via 172.16.42.1 dev eth1")
        end
      end
      before do
        allow(Specinfra::Command::Linux::Base::Inventory).to receive(:get_default_gateway).and_return(
<<EOF
cat << EOF2
default via 172.17.42.1 dev eth0
172.17.0.0/16 dev eth0 proto kernel  scope link  src 172.17.1.5
default via 172.16.42.1 dev eth1
172.16.0.0/16 dev eth1 proto kernel  scope link  src 172.16.1.5
EOF2
EOF
)     end

      describe "iptables" do
        it "should generate about iptables_filter" do
          ret = described_class.execute
          expect(ret.keys).to include(:iptables)
          expect(ret[:iptables].keys.size).to eq(1)
          expect(ret[:iptables].keys).to include(:filter)

          expect(ret[:iptables][:filter].keys.size).to eq(3)
          expect(ret[:iptables][:filter].keys).to include(:input)
          expect(ret[:iptables][:filter].keys).to include(:forward)
          expect(ret[:iptables][:filter].keys).to include(:output)

          expect(ret[:iptables][:filter][:input]).to include("Chain INPUT (policy ACCEPT)")
          expect(ret[:iptables][:filter][:input]).to include("ACCEPT     all")
          expect(ret[:iptables][:filter][:input]).to include("icmp-host-prohibited")

          expect(ret[:iptables][:filter][:forward]).to include("Chain FORWARD (policy ACCEPT)")
          expect(ret[:iptables][:filter][:forward]).to include("REJECT     all")
          expect(ret[:iptables][:filter][:forward]).to include("icmp-host-prohibited")

          expect(ret[:iptables][:filter][:output]).to include("Chain OUTPUT (policy DROP)")
          expect(ret[:iptables][:filter][:output]).to include("ACCEPT     all")
          expect(ret[:iptables][:filter][:output]).to include("udp dpt:ntp")
        end
      end
      before do
        allow(Specinfra::Command::Linux::Base::Inventory).to receive(:get_iptables_filter).and_return(
<<EOF
cat << EOF2
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
ACCEPT     all  --  anywhere             anywhere            state RELATED,ESTABLISHED
REJECT     all  --  anywhere             anywhere            reject-with icmp-host-prohibited

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
REJECT     all  --  anywhere             anywhere            reject-with icmp-host-prohibited

Chain OUTPUT (policy DROP)
target     prot opt source               destination
ACCEPT     all  --  anywhere             anywhere
ACCEPT     udp  --  anywhere             anywhere           udp dpt:ntp
EOF2
EOF
)     end
    end
  end
end
