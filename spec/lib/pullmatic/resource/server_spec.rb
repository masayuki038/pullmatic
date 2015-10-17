require 'spec_helper'

module Pullmatic
  module Resource
    describe Server do
      before do
        property[:host_inventory] = {}
      end
      describe ".execute" do
        it "should generate os_info" do
          ret = described_class.execute
          expect(ret[:os_info]).to eq({:family => "ubuntu", :release => "14.04", :arch => "x86_64"})
        end
      end

      describe ".execute" do
        it "should generate hostname" do
          ret = described_class.execute
          expect(ret[:hostname]).to eq("ip-210-34-33-22")
        end
        before do
          allow(Specinfra::Command::Linux::Base::Inventory).to receive(:get_hostname).and_return(
<<EOF
cat << EOF2
ip-210-34-33-22
EOF2
EOF
)       end
      end

      describe ".execute" do
        it "should generate selinux" do
          ret = described_class.execute
          expect(ret[:selinux]).to eq("disabled")
        end
        before do
          allow(Specinfra::Command::Linux::Base::Inventory).to receive(:get_selinux).and_return("exit 1")
        end
      end

      describe ".execute" do
        it "should generate timezone" do
          ret = described_class.execute
          expect(ret[:timezone]).to eq('ZONE="Asia/Tokyo"')
        end
        before do
          puts "called before"
          allow(Specinfra::Command::Linux::Base::Inventory).to receive(:get_timezone).and_return(
<<EOF
cat << EOF2
ZONE="Asia/Tokyo"
UTC=False
EOF2
EOF
)       end
      end
    end
  end
end
