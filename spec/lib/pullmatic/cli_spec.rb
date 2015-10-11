require 'spec_helper'

module Pullmatic
  describe CLI do
    context "resources" do
      shared_examples "CLI examples" do
        context "print"
        it "should print server spec" do
          expect(klass).to receive(:execute).with(no_args)
          described_class.new.invoke(command, [], {})
        end
      end

      before do
        allow(klass).to receive(:execute).and_return({})
      end

      describe "server" do
        let(:klass) { Pullmatic::Resource::Server }
        let(:command) { :server }

        it_behaves_like "CLI examples"
      end
    end
  end
end
