module Dependagrab
  require "dependagrab/version"
  require 'dependagrab/gh_api'
  require "dependagrab/github_client"
  require "dependagrab/console_writer"
  require "dependagrab/file_writer"

  class Error < StandardError; end
  class MissingConfigError < Dependagrab::Error; end
  class GhApiError < Dependagrab::Error; end
end
