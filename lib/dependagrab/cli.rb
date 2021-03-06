require 'getoptlong'
require 'dependagrab'

module Dependagrab
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
        STDERR.puts "Error: #{e.message}  (set DEBUG=true for detailed backtrace)"
        puts
        print_help
        STDERR.puts e.backtrace if ENV['DEBUG']
        exit 1
      end

      if ARGV.length != 1
        STDERR.puts "Missing REPO argument (try --help for usage)"
        exit 1
      end

      repo = ARGV.shift
      _, options[:owner], options[:repo] = repo.split /([\w_-]+)\/([\w._-]+)$/
      if options[:owner].nil? || options[:repo].nil?
        STDERR.puts "Invalid REPO format"
        exit 1
      end

      begin
        options.merge!(print: true)
        Dependagrab.run(options)
      rescue => e
        STDERR.puts "Error: #{e.message}  (set DEBUG=true for detailed backtrace)"
        STDERR.puts e.backtrace if ENV['DEBUG']
        exit 1
      end
    end

    private

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

