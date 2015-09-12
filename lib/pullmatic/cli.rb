module Pullmatic
  class CLI < Thor
    class_option :print, type: :boolean, desc: "Print STDOUT"
    
    desc "server", "Server spec"
    def server
      execute(Pullmatic::Resource::Server)
    end

    private

    def execute(klass)
      klass.execute
    end
  end
end
