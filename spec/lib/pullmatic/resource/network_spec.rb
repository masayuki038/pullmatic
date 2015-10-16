require 'spec_helper'

module Pullmatic
  module Resource
    describe Network do
      before do
        property[:host_inventory] = {}
      end

      describe "hosts" do
        it "should generate about hosts" do
          ret = described_class.execute
          expect(ret.keys).to include(:hosts)
          expect(ret[:hosts].size).to eq(3)
          expect(ret[:hosts]).to include("127.0.0.1 localhost.localdomain localhost")
          expect(ret[:hosts]).to include("192.168.1.20 test2")
          expect(ret[:hosts]).not_to include("# 192.168.0.1 comment")
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
)       end
      end

      describe "default_gateway" do
        it "should generate about default gateway" do
          ret = described_class.execute
          expect(ret.keys).to include(:default_gateway)
          expect(ret[:default_gateway].size).to eq(2)
          expect(ret[:default_gateway][0]).to eq("default via 172.17.42.1 dev eth0")
          expect(ret[:default_gateway][1]).to eq("default via 172.16.42.1 dev eth1")
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
)       end
      end

      describe "iptables" do
        it "should generate about iptables_filter" do
          ret = described_class.execute
          expect(ret.keys).to include(:iptables)
          expect(ret[:iptables].keys).to include(:filter)

          expect(ret[:iptables][:filter].keys.size).to eq(3)
          expect(ret[:iptables][:filter].keys).to include(:input)
          expect(ret[:iptables][:filter].keys).to include(:forward)
          expect(ret[:iptables][:filter].keys).to include(:output)

          expect(ret[:iptables][:filter][:input][0]).to include("Chain INPUT (policy ACCEPT)")
          expect(ret[:iptables][:filter][:input][1]).to include("ACCEPT     all")
          expect(ret[:iptables][:filter][:input][2]).to include("icmp-host-prohibited")

          expect(ret[:iptables][:filter][:forward][0]).to include("Chain FORWARD (policy ACCEPT)")
          expect(ret[:iptables][:filter][:forward][1]).to include("REJECT     all")
          expect(ret[:iptables][:filter][:forward][1]).to include("icmp-host-prohibited")

          expect(ret[:iptables][:filter][:output][0]).to include("Chain OUTPUT (policy DROP)")
          expect(ret[:iptables][:filter][:output][1]).to include("ACCEPT     all")
          expect(ret[:iptables][:filter][:output][2]).to include("udp dpt:ntp")
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
)       end
      end

      describe "iptables" do
        it "should generate about iptables_nat" do
          ret = described_class.execute
          expect(ret.keys).to include(:iptables)
          expect(ret[:iptables].keys).to include(:nat)

          expect(ret[:iptables][:nat].keys.size).to eq(4)
          expect(ret[:iptables][:nat].keys).to include(:input)
          expect(ret[:iptables][:nat].keys).to include(:output)
          expect(ret[:iptables][:nat].keys).to include(:prerouting)
          expect(ret[:iptables][:nat].keys).to include(:postrouting)

          expect(ret[:iptables][:nat][:input][0]).to include("Chain INPUT (policy ACCEPT)")
          expect(ret[:iptables][:nat][:input][1]).to include("ACCEPT     all")
          expect(ret[:iptables][:nat][:input][2]).to include("icmp-host-prohibited")

          expect(ret[:iptables][:nat][:output][0]).to include("Chain OUTPUT (policy DROP)")
          expect(ret[:iptables][:nat][:output][1]).to include("ACCEPT     all")
          expect(ret[:iptables][:nat][:output][2]).to include("udp dpt:ntp")

          expect(ret[:iptables][:nat][:prerouting][0]).to include("Chain PREROUTING (policy ACCEPT)")
          expect(ret[:iptables][:nat][:prerouting][1]).to include("DNAT")

          expect(ret[:iptables][:nat][:postrouting][0]).to include("Chain POSTROUTING (policy ACCEPT)")
          expect(ret[:iptables][:nat][:postrouting][1]).to include("MASQUERADE")
          expect(ret[:iptables][:nat][:postrouting][1]).to include("!10.0.3.0/24")
          expect(ret[:iptables][:nat][:postrouting][2]).to include("MASQUERADE")
          expect(ret[:iptables][:nat][:postrouting][2]).to include("!172.17.0.0/16")
        end
        before do
          allow(Specinfra::Command::Linux::Base::Inventory).to receive(:get_iptables_nat).and_return(
<<EOF
cat << EOF2
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination
DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:9999 to:192.168.202.105:80

Chain INPUT (policy ACCEPT)
target     prot opt source               destination
ACCEPT     all  --  anywhere             anywhere            state RELATED,ESTABLISHED
REJECT     all  --  anywhere             anywhere            reject-with icmp-host-prohibited

Chain OUTPUT (policy DROP)
target     prot opt source               destination
ACCEPT     all  --  anywhere             anywhere
ACCEPT     udp  --  anywhere             anywhere           udp dpt:ntp

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
MASQUERADE  all  --  10.0.3.0/24         !10.0.3.0/24
MASQUERADE  all  --  172.17.0.0/16       !172.17.0.0/16
EOF2
EOF
)       end
      end
    end
  end
end
