
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dependagrab/version"

Gem::Specification.new do |spec|
  spec.name          = "dependagrab"
  spec.version       = Dependagrab::VERSION
  spec.authors       = ["Dave Elliott"]
  spec.email         = ["ddazza@gmail.com"]

  spec.summary       = %q{Utility for extracting dependency warnings from GitHub}

  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/DDAZZA/dependagrab"


  spec.license       = 'MIT'
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/DDAZZA/dependagrab"
    spec.metadata["changelog_uri"] = "https://github.com/DDAZZA/dependagrab/blob/master/CHange_LOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = 'dependagrab'
  spec.require_paths = ["lib", "static"]

  spec.add_dependency "graphql-client", "0.17.0"
  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.14"
end
