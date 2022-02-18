module Dependagrab
  require "dependagrab/version"
  require 'dependagrab/gh_api'
  require "dependagrab/github_client"
  require "dependagrab/console_writer"
  require "dependagrab/file_writer"

  class Error < StandardError; end
  class MissingConfigError < Dependagrab::Error; end
  class GhApiError < Dependagrab::Error; end


  def self.run(options)
    result = Dependagrab::GithubClient.new(options).grab

    if options[:output]
      begin
        output_file = FileWriter.new(options[:output]).write!(result[:alerts])
        if options[:print]
          puts "#{result[:alerts].count} dependency warnings written to '#{options.fetch(:output)}'"
        end
        output_file
      rescue => e
        STDERR.puts "Failed to write file '#{options.fetch(:output)}'"
        STDERR.puts "Error: #{e.message} (set DEBUG=true for detailed backtrace)"
        STDERR.puts e.backtrace if ENV['DEBUG']
        exit 1
      end
    else
      if options[:print]
        ConsoleWriter.new.write!(result[:alerts])
      else
        result[:alerts]
      end
    end
  end
end
