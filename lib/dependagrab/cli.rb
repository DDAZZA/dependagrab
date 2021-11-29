require 'getoptlong'
require 'dependagrab'

module Dependagrab
  require 'dependagrab/console_writer'
  require 'dependagrab/file_writer'

  class CLI
    def self.start
      opts = GetoptLong.new(
        [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
        [ '--version', '-v', GetoptLong::NO_ARGUMENT ],
        [ '--output', '-o', GetoptLong::REQUIRED_ARGUMENT ],
      )


      options = {}

      begin
        opts.each do |opt, arg|
          case opt
          when '--help'
            print_help
            exit 0
          when '--version'
            puts "dependagrab #{Dependagrab::VERSION}"
            exit 0
          when '--output'
            options[:output] = arg
          end
        end
      rescue GetoptLong::Error => e
        print_help
        exit 1
      end

      if ARGV.length != 1
        STDERR.puts "Missing REPO argument (try --help for usage)"
        exit 1
      end

      repo = ARGV.shift
      _, options[:owner], options[:repo] = repo.split /([\w-]+)\/([\w-]+)$/
      if  options[:owner].nil? || options[:repo].nil?
        STDERR.puts "Invalid REPO format"
        exit 1
      end

      run(options)
    end

    private

    def self.run(options)
      result = Dependagrab::GithubClient.new(options).grab

      if options[:output]
        begin
          FileWriter.new(options[:output]).write!(result[:alerts])
          puts "#{result[:alerts].count} dependency warnings written to '#{options.fetch(:output)}'"
        rescue => e
          STDERR.puts "Failed to write file '#{options.fetch(:output)}'"
          STDERR.puts e.message
          exit 1
        end
      else
        ConsoleWriter.new.write!(result[:alerts])
      end
    end

    def self.print_usage
      puts "Usage: dependagrab <REPO> [Options]"
      puts
    end

    def self.print_help
      print_usage
      puts <<-EOF
<REPO>      GitHub Repository (e.g. DDAZZA/dependagrab)

Options:
  --output        Destination to write JSON file

Misc Options:
  -v, --version   Prints version
  -h, --help      Prints this message

For private repositories you will need to set the GITHUB_API_TOKEN environment variable.
The GitHub documentation provides steps for setup (https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token).
      EOF
    end
  end
end

