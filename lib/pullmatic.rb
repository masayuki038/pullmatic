require 'pry'
require 'thor'
require 'specinfra'
require 'specinfra/helper/set'

require "pullmatic/version"
require "pullmatic/cli"
require "pullmatic/resource/server"

include Specinfra::Helper::Set

module Pullmatic
end
