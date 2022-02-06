# Osu::Api

Hello! This gem is capable of creating an oauth login via osu! and using the current apiv2 requests. 

## Example:

You can login using your osu account. 
After that you can make requests on behalf the user.
Ex: getBeatmaps, getUserScore, getForumpost and more!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'osu-api'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install osu-api

## Usage
First of all you have to implement in either your Frontend or ApplicationController the following lines to do requests in any controller

    class ApplicationController < ActionController::Base
    
        @@osuApi = nil

    def setOsuApi(oauth)
        @@osuApi = oauth 
    end

    def osuApi
        @@osuApi
    end
    
TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/osu-api.
# osu-api
