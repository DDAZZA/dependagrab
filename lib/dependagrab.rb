module Dependagrab
  require "dependagrab/version"
  require "dependagrab/github_client"

  class Error < StandardError; end
  class MissingConfigError < Dependagrab::Error; end
  class GhApiError < Dependagrab::Error; end
end
