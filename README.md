# Dependagrab

Tool for extracting GitHub dependency warnings and converting it into a ThreadFix compatible file

## Installation

Install it with:

    $ gem install dependagrab

## Usage

    `$ dependagrab --help`

    `$ export GITHUB_API_TOKEN=<TOKEN>`
    `$ dependagrab DDAZZA/dependagrab`

## Development

```
$ git clone https://github.com/DDAZZA/dependagrab.git
$ bundle install
$ ruby -Ilib ./bin/dependagrab --help
```

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DDAZZA/dependagrab.
