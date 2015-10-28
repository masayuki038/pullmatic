# Pullmatic

Pullmatic ia a tool for collecting server states and printing as JSON string via SSH.

[![Build Status](https://travis-ci.org/masayuki038/pullmatic.png)](https://travis-ci.org/masayuki038/pullmatic)
[![Coverage Status](https://coveralls.io/repos/masayuki038/pullmatic/badge.svg?branch=master&service=github)](https://coveralls.io/github/masayuki038/pullmatic?branch=master)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pullmatic'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pullmatic

## Usage

Usage: pullmatic export --host=[host] [options]

Options:
    --user ssh user
    --password ssh password
    --sudo_password sudo password

Examples:
```
$ pullmatic export --host=10.14.28.139 > server.json
```


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

