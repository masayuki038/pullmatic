require 'pry'
require 'thor'
require 'specinfra'
require 'specinfra/helper/set'
require 'specinfra/helper/detect_os'
require 'specinfra/backend'

require "pullmatic/version"
require "pullmatic/cli"
require "pullmatic/resource/server"
require "pullmatic/resource/filesystem"

include Specinfra::Helper::Set

module Pullmatic
  set :backend, :exec
end
