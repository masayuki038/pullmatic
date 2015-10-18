require 'pry'
require 'thor'
require 'oj'
require 'specinfra'
require 'specinfra/helper/set'
require 'specinfra/helper/detect_os'
require 'specinfra/backend'

require "pullmatic/version"
require "pullmatic/cli"
require "pullmatic/resource/server"
require "pullmatic/resource/filesystem"
require "pullmatic/resource/interface"
require "pullmatic/resource/network"
require "pullmatic/resource/user_group"

include Specinfra::Helper::Set

module Pullmatic
  set :backend, :exec
end
