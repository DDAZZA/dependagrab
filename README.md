# Dependagrab
Utility for extracting dependency warnings from GitHub

[![Gem Version](https://badge.fury.io/rb/dependagrab.svg)](https://badge.fury.io/rb/dependagrab)


## Installation

*with ruby*
```bash
$ gem install dependagrab
#=> Fetching dependagrab-0.1.6.gem
#=> Successfully installed dependagrab-0.1.6
#=> 1 gem installed
```

*with docker*
```bash
$ docker pull ddazza/dependagrab:latest
```

### Configure
[Setup a GitHub access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
```bash
export GITHUB_API_TOKEN=<token> 
```

## Usage

*with ruby*
```bash
# Usage: dependagrab <REPO> [Options]
# e.g. dependagrab DDAZZA/foo

# or to write to a file
dependagrab DDAZZA/foo --output ./foo.json
#=> 3 dependency warnings written to './foo.json'

```

*with docker*
```bash
docker run --rm --env GITHUB_API_TOKEN --volume `pwd`:/output \
  ddazza/dependagrab:latest DDAZZA/foo --output /output/foo.json
  #=> 3 dependency warnings written to '/output/foo.json'
```

## Development

```
$ git clone https://github.com/DDAZZA/dependagrab.git
$ bundle install
$ bundle exec rake install
$ dependagrab --help
```

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DDAZZA/dependagrab.
