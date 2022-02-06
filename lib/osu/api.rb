# frozen_string_literal: true

require_relative "api/version"
require 'oauth2'

module Osu
  module Api
    class Error < StandardError; end
    class OAuth 
      #mods = ["HD"]
      @@token = nil
      @@user_id = nil

      @@authorize_url = '/oauth/authorize' # ?scope=public set by default in initialize
      @@idp_url='https://osu.ppy.sh/'
      @@token_url='/oauth/token'

      def initialize(client_id, client_secret, redirect_uri, scope='public')
        super(client_id,
          client_secret, 
          authorize_url: "#{@@authorize_url}?scope=#{scope}", 
          site: @@idp_url, 
          token_url: @@token_url, 
          redirect_uri: redirect_uri
        )
      end

      def setToken(code)
        @@token = self.auth_code.get_token(code)
      end
      def getToken
        @@token
      end
      # def setAccessToken
      #   session[:access_token] = @@token.to_hash[:access_token]
      # end

      def getAccessToken
        @@token.to_hash[:access_token]
      end

      #############################
      ####### User Requests #######
      #############################
      
      def getOwnData(mode='osu') # mania, taiko, fruits (yes, ctb is called fruits)
        data = @@token.get("api/v2/me/#{mode}").parsed
        setUserId(data["id"])
        data
      end

      ## TO DO ##
      def getUserKudosu(user_id, options) # required: user_id
                                          # optional: limit, offset
        if !options
          @@token.get("api/v2/users/#{user_id}/kudosu")
        elsif options[:limit] && !options[:offset]
          @@token.get("api/v2/users/#{user_id}/kudosu?limit=#{options[:limit]}")
        elsif !options[:limit] && options[:offset]
          @@token.get("api/v2/users/#{user_id}/kudosu?offset=#{options[:offset]}")
        elsif options[:limit] && options[:offset]
          @@token.get("api/v2/users/#{user_id}/kudosu?limit=#{options[:limit]}&offset=#{options[:offset]}")
        end
      end
      ## TO DO ##
      def getUserScores(user_id, type, options) # required: user_id, type (best, firsts, recent)
                                                # optional: include_fails, mode, limit, offset
        if options[:include_fails] && !options[:mode] && !options[:limit] && !options[:offset]
        elsif options[:include_fails] && options[:mode] && !options[:limit] && !options[:offset]
        elsif options[:include_fails] && options[:mode] && options[:limit] && !options[:offset]
        elsif options[:include_fails] && options[:mode] && options[:limit] && options[:offset]
        
        elsif !options[:include_fails] && options[:mode] && !options[:limit] && !options[:offset]
        elsif !options[:include_fails] && options[:mode] && options[:limit] && !options[:offset]
        elsif !options[:include_fails] && options[:mode] && !options[:limit] && options[:offset]
        elsif !options[:include_fails] && options[:mode] && !options[:limit] && !options[:offset]

        elsif !options[:include_fails] && !options[:mode] && options[:limit] && !options[:offset]
        elsif !options[:include_fails] && !options[:mode] && options[:limit] && options[:offset]
        elsif options[:include_fails] && !options[:mode] && !options[:limit] && options[:offset]
        elsif !options[:include_fails] && options[:mode] && !options[:limit] && !options[:offset]
          # FINISH OMG WAT IS DAT
        end
      end
      def getUserBeatmaps(user_id, type, options) # required: user_id, type
                                                  # optional: limit, offset
        if user_id && type && !options
          @@token.get("api/v2/users/#{user_id}/beatmapsets/#{type}")
        elsif options[:limit] && !options[:offset]
          @@token.get("api/v2/users/#{user_id}/beatmapsets/#{type}?limit=#{options[:limit]}")
        elsif options[:offset] && !options[:limit]
          @@token.get("api/v2/users/#{user_id}/beatmapsets/#{type}?offset=#{options[:limit]}")
        elsif options[:limit] && options[:offset]
          @@token.get("api/v2/users/#{user_id}/beatmapsets/#{type}?limit=#{options[:limit]}&offset=#{options[:offset]}")
        end
      end
      ## TO DO ##
      def getUserRecentActivities(user_id, options)  # required: user_id
                                            # optional: limit, offset
        if user_id && !options
          @@token.get("api/v2/users/#{user_id}/recent_activities")          
        elsif options[:limit] && !options[:offset]
          @@token.get("api/v2/users/#{user_id}/recent_activities?limit=#{options[:limit]}")
        elsif options[:offset] && !options[:limit]
          @@token.get("api/v2/users/#{user_id}/recent_activities?offset=#{options[:offset]}")
        elsif options[:limit] && options[:offset]
          @@token.get("api/v2/users/#{user_id}/recent_activities?limit=#{options[:limit]}&offset=#{options[:offset]}")
        end
        
      end
      ## TO DO ##

      def getUser(*args)  # required: user_id, mode
                          # optional: key
        case args.size
          when 2
            @@token.get("api/v2/users/#{args[0]}/#{args[1]}")
          when 3
            @@token.get("api/v2/users/#{args[0]}/#{args[1]}?key=#{args[2]}")
        end
      end

      def getUserId
        @@user_id
      end

      ################################
      ####### Beatmap Requests #######
      ################################

      ## TO DO ##
      def lookupBeatmap(optional) # optional (one of them is required): checksum, filename, id
        if optional[:checksum] && !optional[:filename] && !optional[:id]
        end
        @@token.get("api/v2/beatmaps/lookup")
      end
      ## TO DO ##
      def getUserBeatmapScore(beatmap_id, user_id, options) # required: beatmap_id, user_id
                                                            # optional: mode, mods
        if !options
          @@token.get("api/v2/beatmaps/#{beatmap_id}/scores/users/#{user_id}").parsed
        elsif options[:mode] && !options[:mods]
          @@token.get("api/v2/beatmaps/#{beatmap_id}/scores/users/#{user_id}?mode=#{options[:mode]}").parsed
        elsif !options[:mode] && options[:mods]
          @@token.get("api/v2/beatmaps/#{beatmap_id}/scores/users/#{user_id}?mods[]=#{options[:mods]}").parsed
        elsif options[:mode] && options[:mods]
          @@token.get("api/v2/beatmaps/#{beatmap_id}/scores/users/#{user_id}?mode=#{options[:mode]}&mods[]=#{options[:mods]}").parsed
        end
      end
      ## TO DO ##
      def getBeatmapScores(*args) # required: beatmap_id
                                  # optional: mode, mods (ONLY IF YOU ARE SUPPORTER), type
        @@token.get("api/v2/beatmaps/#{beatmap_id}/scores")
      end
      ## TO DO ##
      def getBeatmaps(*beatmaps) # soon api/v2/beatmaps?ids[]=12345&ids[]=45678&ids[]=8934939
        query = "ids[]="
        full_query
        for x in *beatmaps
          full_query = "#{query + x}&"
        end
        debugger
      end

      def getBeatmap(beatmap_id) # https://osu.ppy.sh/beatmapsets/39804#osu/129891  (129891 gonna be the ID cuz its a beatmapset)
        @@token.get("api/v2/beatmaps/#{beatmap_id}").parsed
      end


      def getForumpost(forumpost_id)
        @@token.get("api/v2/forums/topics/#{forumpost_id}").parsed
      end
                                        
      def getMatch(match_id)
        @@token.get("api/v2/matches/#{match_id}").parsed
      end
      

      def getRanking(mode, type)
        @@token.get("api/v2/rankings/#{mode}/#{type}")
      end


      def getMostRecentMatches # 50 latest created matches
        @@token.get("api/v2/matches")
      end

      def getSpotlights
        @@token.get("api/v2/spotlights")
      end

      # Remove after finished
      def api(uri)
        @@token.get(uri).parsed
      end

      private
      def setUserId(id)
        @@user_id = id
      end

      private
      def apiRequest(url, params = "")
        if url.nil?
            return "Url nil!"
        end
        if params.nil?
            params = ""
        end
        headers = {
            "Content-Type" => "application/json",
            "Accept" => "application/json",
            "Authorization" => "Bearer #{access_token}"
        }
        response = HTTParty.get(url,
            body: params.to_json,
            headers: headers
        )
        response.parsed_response
      end
    end
  end
end
