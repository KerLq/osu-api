# frozen_string_literal: true

require_relative "api/version"
require 'oauth2'
require 'httparty'

module Osu
  module Api
    class Error < StandardError; end
    class Api
      API_URI = 'https://osu.ppy.sh/'
      @@access_token = nil
      
      def initialize(session_token)
        @@access_token = session_token
      end

      def getUser(user_id, mode: 'osu', key: nil)  # required: user_id
        get("api/v2/users/#{user_id}/#{mode}?key=#{key}")
      end
     
      def getBeatmap(beatmap_id) # https://osu.ppy.sh/beatmapsets/39804#osu/129891  (129891 gonna be the ID cuz its a beatmapset)
        get("api/v2/beatmaps/#{beatmap_id}")
      end

      def getUserKudosu(user_id, limit: nil, offset: nil)
        get("api/v2/users/#{user_id}/kudosu?limit=#{limit}&offset=#{offset}")
      end

      def getUserScores(user_id, type, include_fails: nil, mode: "osu", limit: nil, offset: nil)
        get("api/v2/users/#{user_id}/scores/#{type}?include_fails=#{include_fails}&mode=#{mode}&limit=#{limit}&offset=#{offset}")
      end

      def getUserBeatmaps(user_id, type, limit: nil, offset: nil)
        get("api/v2/users/#{user_id}/beatmapsets/#{type}?limit=#{limit}&offset=#{offset}")
      end

      def getUserRecentActivity(user_id, limit: nil, offset: nil)
        get("api/v2/users/#{user_id}/recent_activity?limit=#{limit}&offset=#{offset}")
      end

      def lookupBeatmap(checksum: nil, filename: nil, id: nil)
        get("api/v2/beatmaps/lookup?checksum=#{checksum}&filename=#{filename}&id=#{id}")
      end

      def getUserBeatmapScore(beatmap_id, user_id, mode: nil, mods: nil) # mods only possible if the user has osu!supporter
        if mods.present?
          get("api/v2/beatmaps/#{beatmap_id}/scores/users/#{user_id}?mode=#{mode}&mods[]=#{mods}")
        else
          get("api/v2/beatmaps/#{beatmap_id}/scores/users/#{user_id}?mode=#{mode}")
        end
      end

      def getBeatmapScores(beatmap_id, mode: nil, mods: nil, type: nil) # mods only possible if the user has osu!supporter
        if mods.present?
          get("api/v2/beatmaps/#{beatmap_id}/scores?mode=#{mode}&type=#{type}&mods[]=#{mods}")
        else
          get("api/v2/beatmaps/#{beatmap_id}/scores?mode=#{mode}&type=#{type}")
        end
      end

      def getBeatmaps(*beatmaps) # "api/v2/beatmaps?ids[]=12345&ids[]=45678&ids[]=8934939"
        beatmaps_query = createQuery('ids[]=', beatmaps)
        get("api/v2/beatmaps?#{beatmaps_query}")
      end

      def getForumpost(forumpost_id, cursor_string: nil, sort: nil, limit: nil, start: nil, ending: nil)
        get("api/v2/forums/topics/#{forumpost_id}?cursor_string=#{cursor_string}&sort=#{sort}&limit=#{limit}&start=#{start}&end=#{ending}")
      end
                                        
      def getMatch(match_id)
        get("api/v2/matches/#{match_id}")
      end
      

      def getRanking(mode, type, country: nil, cursor: nil, filter: all, spotlight: nil, variant: nil)
        get("api/v2/rankings/#{mode}/#{type}?country=#{country}&cursor=#{cursor}&filter=#{filter}&spotlight=#{spotlight}&variant=#{variant}")
      end

      def search(mode: all, query: nil, page: nil) # mode: all, user or wiki_page
        get("api/v2/search?mode#{mode}&query=#{query}&page=#{page}")
      end
      def getMostRecentMatches(limit: 50) # 50 latest created matches
        get("api/v2/matches?limit=#{limit}")
      end

      def getSpotlights
        get("api/v2/spotlights")
      end

      def getBeatmapsetsEvents
        get("api/v2/beatmapsets/events")
      end

      def getSeasonalBackgrounds
        get("api/v2/seasonal-backgrounds")
      end

      private
      def get(uri)
        url = "#{API_URI}#{uri}"
        headers = {
            "Content-Type" => "application/json",
            "Accept" => "application/json",
            "Authorization" => "Bearer #{@@access_token}"
        }
        response = HTTParty.get(url,
            headers: headers
        )
        response.parsed_response
      end
      private
      def createQuery(query, array)
        full_query = ""
        for x in array
          full_query = "#{full_query + query + x}&"
        end
        full_query = full_query[0..-2]
      end

    end
    class OAuth < OAuth2::Client
      @@token = nil

      @@authorize_url = '/oauth/authorize' # ?scope=public set by default in initialize
      @@idp_url='https://osu.ppy.sh/'
      @@token_url='/oauth/token'

      def initialize(client_id, client_secret, redirect_uri, scope: 'identify') # Scopes => https://osu.ppy.sh/docs/index.html#scopes
        super(client_id,
          client_secret, 
          authorize_url: "#{@@authorize_url}?scope=#{scope}", 
          site: @@idp_url, 
          token_url: @@token_url, 
          redirect_uri: redirect_uri
        )
      end

      def getAccessToken
        @@token.to_hash[:access_token]
      end

      def setToken(code)
        @@token = self.auth_code.get_token(code)
      end

      def getOwnData(mode = 'osu') # mania, taiko, fruits (yes, ctb is called fruits)
        data = @@token.get("api/v2/me/#{mode}").parsed
        data
      end
    end
  end
end
