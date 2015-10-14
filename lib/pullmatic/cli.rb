module Pullmatic
  class CLI < Thor
    class_option :print, type: :boolean, desc: "Print STDOUT"


    desc "export", "export server info as json/excel"
    option :host, :required => true
    option :user
    option :password
    option :sudo_password
    option :format, default: "json", :type => :string, :enum => %w(json excel)
    def export
      set :backend, "ssh"
      set :host, options[:host]
      ssh_options = {}
      ssh_options[:user] = options[:user] if options[:user]
      ssh_options[:password] = options[:password] if options[:password]
      set :ssh_options, ssh_options
      set :sudo_password, options[:sudo_password] if options[:sudo_password]

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pullmatic/version'

Gem::Specification.new do |spec|
  spec.name          = "pullmatic"
  spec.version       = Pullmatic::VERSION
  spec.authors       = ['Masayuki Takahashi']
  spec.email         = ['masayuki038@gmail.com']

  spec.summary       = %q{A tool to export linux server configurations.}
  spec.description   = %q{A tool to export linux server configurations via ssh.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"

  spec.add_dependency "specinfra", "~> 2.40"
  spec.add_dependency "oj"
  spec.add_dependency "ox"
  spec.add_dependency "thor"
  spec.add_dependency "rubyXL", "3.3.13"
end
      server = get_server
      filesystem = get_filesystem
      interface = get_interface
      network = get_network
    end

    private

    def shell
      @shell ||= Thor::Base.shell.new
    end

    def get_server
      execute(Pullmatic::Resource::Server)
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

    def execute(klass)
      klass.execute
    end
  end
end
