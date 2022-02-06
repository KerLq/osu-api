# Osu::Api

Hello! This gem is capable of creating an oauth login via osu! and using the current apiv2 requests. 

## Example:

You can login using your osu account. 
After that you can make requests on behalf the user.
Ex: getBeatmaps, getUserScore, getForumpost and more!

The majority isn't completed so I'll list the one that 100% works
I recommend you looking into the code too

Requests that generally work and **without** passing optional parameters:
getOwnData
getUserScores
getUserBeatmapScore
getBeatmap
getForumpost
getMatch
getRanking
getMostRecentMatches
getSpotlights

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

You have to create an OAuthController

    rails g controller oauth

Navigate into your OAuthController and implement a initialize method to create the OAuth instance

    class OAuthController < ApplicationController
        def initialize

            @osuApi = Osu::Oauth::OsuOauth.new(
              Rails.configuration.x.oauth.client_id,
              Rails.configuration.x.oauth.client_secret,
              Rails.configuration.x.oauth.redirect_uri
            )
            setOsuApi(@osuApi) ## setOsuApi is a method located in ApplicationController
        end
        
Next implement login & logout methods

    def login
        redirect_to @osuApi.auth_code.authorize_url
    end
      
    def logout
        # Either revoke token (check osu! api docs) or reset session
        reset_session
        redirect_to YOUR_PATH
    end

Now we have to implement the oauth callback method to exchange our authorization code for an access token

    def oauth_callback
    
        # Set token for osuApi to allow global use
        osuApi.setToken(params[:code])

        # Get your own data
        player = osuApi.getPlayer

        # Create a user with needed params
        user = User.create_from_oauth(player)
        # Set session for user
        session[:user_id] = user.id

        redirect_to YOUR_PATH
    end

Now we're done implementing the OAuthController but a user has to be created.

Navigate to your User Model

    class User < ApplicationRecord
    
        def self.create_from_oauth(params)
            user = User.find_or_create_by(user_id: params['id']) do |u|
                u.id = params['id']
                u.username = params['username']
                u.avatar_url = params['avatar_url']
            end
        end
Good job! The user gets created after login via oauth! But wait, there are no routes set. 
Go into your routes.rb

    Rails.application.routes.draw do
        get '/oauth2-callback', to: 'oauth#oauth_callback'
        get '/logout', to: 'oauth#logout'
        get '/login', to: 'oauth#login'
    end

Our final step is to add the following code into your ApplicationController

    class ApplicationController < ActionController::Base
    
        @@osuApi = nil

        def setOsuApi(oauth)
            @@osuApi = oauth 
        end

        def osuApi
            @@osuApi
        end
    end
    
Nice! Everything is set and good to go!

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/osu-api.
# osu-api
