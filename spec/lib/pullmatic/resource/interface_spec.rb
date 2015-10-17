require 'spec_helper'

module Pullmatic
  module Resource
    describe Interface do
      before do
        property[:host_inventory] = {}
      end
      describe ".execute" do
        it "should generate ip" do
          ret = described_class.execute
          expect(ret.keys).to include(:ip)
          expect(ret[:ip].keys).to include("lo")
          expect(ret[:ip]["lo"][:ipv4]).to eq("127.0.0.1/8")
          expect(ret[:ip]["lo"][:ipv6]).to eq("::1/128")
          expect(ret[:ip].keys).to include("eth0")
          expect(ret[:ip]["eth0"][:ipv4]).to eq("153.121.33.44/23")
          expect(ret[:ip]["eth0"][:ipv6]).to eq("fe80::5054:dff:fe00:2267/64")
        end
        before do
          allow(Specinfra::Command::Linux::Base::Inventory).to receive(:get_ip).and_return(
<<EOF
cat << EOF2
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 52:54:0d:00:22:67 brd ff:ff:ff:ff:ff:ff
    inet 153.121.33.44/23 brd 153.121.33.255 scope global eth0
    inet6 fe80::5054:dff:fe00:2267/64 scope link
       valid_lft forever preferred_lft forever
EOF2
EOF
)
        end
      end

      describe "default_gateway" do
        it "should generate about default gateway" do
          ret = described_class.execute
          expect(ret.keys).to include(:default_gateway)
          expect(ret[:default_gateway].size).to eq(4)
          expect(ret[:default_gateway][0]).to eq("default via 172.17.42.1 dev eth0")
          expect(ret[:default_gateway][1]).to eq("172.16.42.1 dev eth1")
          expect(ret[:default_gateway][2]).to eq("172.17.0.0/16 dev eth0 proto kernel  scope link  src 172.17.1.5")
          expect(ret[:default_gateway][3]).to eq("172.16.0.0/16 dev eth1 proto kernel  scope link  src 172.16.1.5")
        end
        before do
          allow(Specinfra::Command::Linux::Base::Inventory).to receive(:get_default_gateway).and_return(
<<EOF
cat << EOF2
default via 172.17.42.1 dev eth0
172.16.42.1 dev eth1
172.17.0.0/16 dev eth0 proto kernel  scope link  src 172.17.1.5
172.16.0.0/16 dev eth1 proto kernel  scope link  src 172.16.1.5
EOF2
EOF
)       end
      end
    end
  end
end
