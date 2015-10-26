module Pullmatic
  class CLI < Thor
    class_option :print, type: :boolean, desc: "Print STDOUT"

    desc "export", "export server info as json/excel"
    option :host, :required => true
    option :user
    option :password
    option :sudo_password
    def export
      set :backend, "ssh"
      set :request_pty, true
      set :host, options[:host]
      ssh_options = {}
      ssh_options[:user] = options[:user] if options[:user]
      ssh_options[:password] = options[:password] if options[:password]
      set :ssh_options, ssh_options
      set :sudo_password, options[:sudo_password] if options[:sudo_password]

      os = get_os
      filesystem = get_filesystem
      interface = get_interface
      network = get_network
      user_group = get_user_group
      etc = get_etc

      puts Oj.dump({:os => os, :filesystem => filesystem, :interface => interface, :network => network, :user_group => user_group, :etc => etc}, {:indent => 1})
    end

    private

    desc "get_server", "get_server"
    def get_os
      execute(Pullmatic::Resource::Os)
    end

    def get_filesystem
      execute(Pullmatic::Resource::Filesystem)
    end

    def get_interface
      execute(Pullmatic::Resource::Interface)
    end

    def get_network
      execute(Pullmatic::Resource::Network)
    end

    def get_user_group
      execute(Pullmatic::Resource::UserGroup)
    end

    def get_etc
      execute(Pullmatic::Resource::Etc)
    end

    def execute(klass)
      klass.execute
    end
  end
end
