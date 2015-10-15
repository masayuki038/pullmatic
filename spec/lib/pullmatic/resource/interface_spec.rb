require 'spec_helper'

module Pullmatic
  module Resource
    describe Interface do
      describe ".execute" do
        it "should generate interface" do
          ret = described_class.execute
          expect(ret.keys.size).to eq(2)
          expect(ret.keys).to include("lo")
          expect(ret["lo"][:ipv4]).to eq("127.0.0.1/8")
          expect(ret["lo"][:ipv6]).to eq("::1/128")
          expect(ret.keys).to include("eth0")
          expect(ret["eth0"][:ipv4]).to eq("153.121.33.44/23")
          expect(ret["eth0"][:ipv6]).to eq("fe80::5054:dff:fe00:2267/64")
        end
      end
      before do
        allow(Specinfra::Command::Linux::Base::Inventory).to receive(:get_interface).and_return(
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
  end
end
