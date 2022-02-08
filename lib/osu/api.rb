# frozen_string_literal: true

require_relative "api/version"
require 'oauth2'

module Osu
  module Api
    class Error < StandardError; end
    class OAuth < OAuth2::Client
      #mods = ["HD"]
      @@token = nil
      @@user_id = nil
      @@is_supporter = false

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
        @@user_id = data["id"]
        @@is_supporter = data["is_supporter"]
        data
      end

      ## TO DO ##
      # def getUserKudosu(user_id, options = {})          # required: user_id
      #                                                   # optional: limit, offset
      #   if options.empty?
      #     @@token.get("api/v2/users/#{user_id}/kudosu")
      #   elsif options[:limit] && options[:offset].nil?
      #     @@token.get("api/v2/users/#{user_id}/kudosu?limit=#{options[:limit]}")
      #   elsif options[:limit].nil? && options[:offset]
      #     @@token.get("api/v2/users/#{user_id}/kudosu?offset=#{options[:offset]}")
      #   elsif options[:limit] && options[:offset]
      #     @@token.get("api/v2/users/#{user_id}/kudosu?limit=#{options[:limit]}&offset=#{options[:offset]}")
      #   end
      # end

      def getUserKudosu(user_id, limit: nil, offset: nil)
        @@token.get("api/v2/users/#{user_id}/kudosu?limit=#{limit}&offset=#{offset}")

      end
      ## TO DO ##
      # def getUserScores(user_id, type, options = {}) # required: user_id, type (best, firsts, recent)
      #                                                # optional: include_fails, mode, limit, offset
      #   if options[:include_fails] && options[:mode] && options[:limit] && options[:offset]
      #     @@token.get("api/v2/users/#{user_id}/scores/#{type}?include_fails=#{options[:include_fails]}&mode=#{options[:mode]}&limit=#{options[:limit]}&offset=#{options[:offset]}")
      #   elsif options[:include_fails] && options[:mode] && options[:limit] && options[:offset].nil?
      #     @@token.get("api/v2/users/#{user_id}/scores/#{type}?include_fails=#{options[:include_fails]}&mode=#{options[:mode]}&limit=#{options[:limit]}")
      #   elsif options[:include_fails] && options[:mode] && options[:limit].nil? && options[:offset].nil?
      #     @@token.get("api/v2/users/#{user_id}/scores/#{type}?include_fails=#{options[:include_fails]}&mode=#{options[:mode]}")
      #   elsif options[:include_fails] && options[:mode].nil? && options[:limit].nil? && options[:offset]
      #     @@token.get("api/v2/users/#{user_id}/scores/#{type}?include_fails=#{options[:include_fails]}&offset=#{options[:offset]}")
      #   elsif options[:include_fails] && options[:mode].nil? && options[:limit] && options[:offset].nil?
      #     @@token.get("api/v2/users/#{user_id}/scores/#{type}?include_fails=#{options[:include_fails]}&limit=#{options[:limit]}")
      #   elsif options[:include_fails] && options[:mode].nil? && options[:limit] && options[:offset]
      #     @@token.get("api/v2/users/#{user_id}/scores/#{type}?include_fails=#{options[:include_fails]}&limit=#{options[:limit]}&offset=#{options[:offset]}")
      #   elsif options[:include_fails] && options[:mode] && options[:limit].nil? && options[:offset]
      #     @@token.get("api/v2/users/#{user_id}/scores/#{type}?include_fails=#{options[:include_fails]}&mode=#{options[:mode]}&offset=#{options[:offset]}")
      #   elsif options[:include_fails].nil? && options[:mode] && options[:limit].nil? && options[:offset]
      #     @@token.get("api/v2/users/#{user_id}/scores/#{type}?mode=#{options[:mode]}&offset=#{options[:offset]}")
      #   elsif options[:include_fails].nil? && options[:mode] && options[:limit] && options[:offset].nil?
      #     @@token.get("api/v2/users/#{user_id}/scores/#{type}?mode=#{options[:mode]}&limit=#{options[:limit]}")
      #   elsif options[:include_fails].nil? && options[:mode].nil? && options[:limit] && options[:offset]
      #     @@token.get("api/v2/users/#{user_id}/scores/#{type}?limit=#{options[:limit]}&offset=#{options[:offset]}")
      #   elsif options[:include_fails].nil? && options[:mode] && options[:limit].nil? && options[:offset]
      #     @@token.get("api/v2/users/#{user_id}/scores/#{type}?mode=#{options[:mode]}&offset=#{options[:offset]}")
      #   elsif options[:include_fails] && options[:mode].nil? && options[:limit].nil? && options[:offset].nil?
      #     @@token.get("api/v2/users/#{user_id}/scores/#{type}?include_fails=#{options[:include_fails]}")
      #   elsif options[:include_fails].nil? && options[:mode] && options[:limit].nil? && options[:offset].nil?
      #     @@token.get("api/v2/users/#{user_id}/scores/#{type}?mode=#{options[:mode]}")
      #   elsif options[:include_fails].nil? && options[:mode].nil? && options[:limit] && options[:offset].nil?
      #     @@token.get("api/v2/users/#{user_id}/scores/#{type}?limit=#{options[:limit]}")
      #   elsif options[:include_fails].nil? && options[:mode].nil? && options[:limit].nil? && options[:offset]
      #     @@token.get("api/v2/users/#{user_id}/scores/#{type}?offset=#{options[:mode]}")
      #   elsif options.empty?
      #     @@token.get("api/v2/users/#{user_id}/scores/#{type}")
      #   end
      # end
      
      def getUserScores(user_id, type, include_fails: nil, mode: "osu", limit: nil, offset: nil)
        @@token.get("api/v2/users/#{user_id}/scores/#{type}?include_fails=#{include_fails}&mode=#{mode}&limit=#{limit}&offset=#{offset}").parsed
      end

      # def getUserBeatmaps(user_id, type, options = {}) # required: user_id, type
      #                                                  # optional: limit, offset
      #   if options.empty?
      #     @@token.get("api/v2/users/#{user_id}/beatmapsets/#{type}")
      #   elsif options[:limit] && options[:offset].nil?
      #     @@token.get("api/v2/users/#{user_id}/beatmapsets/#{type}?limit=#{options[:limit]}")
      #   elsif options[:offset] && options[:limit].nil?
      #     @@token.get("api/v2/users/#{user_id}/beatmapsets/#{type}?offset=#{options[:limit]}")
      #   elsif options[:limit] && options[:offset]
      #     @@token.get("api/v2/users/#{user_id}/beatmapsets/#{type}?limit=#{options[:limit]}&offset=#{options[:offset]}")
      #   end
      # end
    
      def getUserBeatmaps(user_id, type, limit: nil, offset: nil)
        @@token.get("api/v2/users/#{user_id}/beatmapsets/#{type}?limit=#{limit}&offset=#{offset}")
      end
      ## TO DO ##
      # def getUserRecentActivity(user_id, options = {})  # required: user_id
      #                                                   # optional: limit, offset
        
      #   if options.empty?
      #     @@token.get("api/v2/users/#{user_id}/recent_activity").parsed          
      #   elsif options[:limit] && options[:offset].nil?
      #     @@token.get("api/v2/users/#{user_id}/recent_activity?limit=#{options[:limit]}").parsed
      #   elsif options[:offset] && options[:limit].nil?
      #     @@token.get("api/v2/users/#{user_id}/recent_activity?offset=#{options[:offset]}").parsed
      #   elsif options[:limit] && options[:offset]
      #     @@token.get("api/v2/users/#{user_id}/recent_activity?limit=#{options[:limit]}&offset=#{options[:offset]}").parsed
      #   end
      # end

      def getUserRecentActivity(user_id, limit: nil, offset: nil)
        @@token.get("api/v2/users/#{user_id}/recent_activity?limit=#{limit}&offset=#{offset}").parsed
      end
      def getUser(user_id, mode: osu, key: nil)  # required: user_id
          @@token.get("api/v2/users/#{user_id}/#{mode}?key=#{key}").parsed
      end
      

      def getUserId
        @@user_id
      end

      def isSupporter?
        @@is_supporter
      end

      ################################
      ####### Beatmap Requests #######
      ################################

      # def lookupBeatmap(optional = {}) # optional (one of them is required): checksum, filename, id
      #   if optional[:checksum] && optional[:filename] && optional[:id]
      #     @@token.get("api/v2/beatmaps/lookup?checksum=#{optional[:checksum]}&filename=#{optional[:filename]}&id=#{optional[:id]}")
      #   elsif optional[:checksum] && optional[:filename] && optional[:id].nil?
      #     @@token.get("api/v2/beatmaps/lookup?checksum=#{optional[:checksum]}&filename=#{optional[:filename]}")
      #   elsif optional[:checksum] && optional[:filename].nil? && optional[:id].nil?
      #     @@token.get("api/v2/beatmaps/lookup?checksum=#{optional[:checksum]}")
      #   elsif optional[:checksum] && optional[:filename].nil? && optional[:id]
      #     @@token.get("api/v2/beatmaps/lookup?checksum=#{optional[:checksum]}&id=#{optional[:id]}")
      #   elsif optional[:checksum].nil? && optional[:filename] && optional[:id]
      #     @@token.get("api/v2/beatmaps/lookup?filename=#{optional[:filename]}&id=#{optional[:id]}")
      #   elsif optional[:checksum].nil? && optional[:filename].nil? && optional[:id]
      #     @@token.get("api/v2/beatmaps/lookup?id=#{optional[:id]}")
      #   elsif optional[:checksum].nil? && optional[:filename] && optional[:id].nil?
      #     @@token.get("api/v2/beatmaps/lookup?filename=#{optional[:filename]}")
      #   end
      # end

      def lookupBeatmap(checksum: nil, filename: nil, id: nil)
        @@token.get("api/v2/beatmaps/lookup?checksum=#{checksum}&filename=#{filename}&id=#{id}")

      end
      ## TO DO ##
      # def getUserBeatmapScore(beatmap_id, user_id, options = {}) # required: beatmap_id, user_id
      #                                                       # optional: mode, mods
      #   if options.empty?
      #     @@token.get("api/v2/beatmaps/#{beatmap_id}/scores/users/#{user_id}").parsed
      #   elsif options[:mode] && !options[:mods]
      #     @@token.get("api/v2/beatmaps/#{beatmap_id}/scores/users/#{user_id}?mode=#{options[:mode]}").parsed
      #   elsif !options[:mode] && options[:mods]
      #     @@token.get("api/v2/beatmaps/#{beatmap_id}/scores/users/#{user_id}?mods[]=#{options[:mods]}").parsed
      #   elsif options[:mode] && options[:mods]
      #     @@token.get("api/v2/beatmaps/#{beatmap_id}/scores/users/#{user_id}?mode=#{options[:mode]}&mods[]=#{options[:mods]}").parsed
      #   end
      # end
      def getUserBeatmapScore(beatmap_id, user_id, mode: nil, mods: nil)
        if mods.present? && @@is_supporter
          @@token.get("api/v2/beatmaps/#{beatmap_id}/scores/users/#{user_id}?mode=#{mode}&mods[]=#{mods}")
        elsif mods.present? && !@@is_supporter
          raise "You can't specifiy mods since you do not have osu!supporter"
        else
          @@token.get("api/v2/beatmaps/#{beatmap_id}/scores/users/#{user_id}?mode=#{mode}")
        end
      end
      ## TO DO ##
      # def getBeatmapScores(beatmap_id, options = {}) # required: beatmap_id
      #                             # optional: mode, mods (ONLY IF YOU ARE SUPPORTER), type
      #   mods_query = ""
      #   if options[:mods]
      #     if options[:mods].count > 1
      #       mods_query = createQuery("mods[]=", options[:mods])
      #     end
      #   end
      #   case
      #     when options[:mode] && options[:type] && options[:mods].nil?
      #       @@token.get("api/v2/beatmaps/#{beatmap_id}/scores?mode=#{options[:mode]}&type=#{options[:type]}")
      #     when options[:mode].nil? && options[:type] && options[:mods]
      #       @@token.get("api/v2/beatmaps/#{beatmap_id}/scores?type=#{options[:type]}&mods[]=#{options[:mods]}")
      #     when options[:mode].nil? && options[:type].nil? && options[:mods]
      #       @@token.get("api/v2/beatmaps/#{beatmap_id}/scores?mods[]=#{options[:mods]}")
      #     when options[:mode] && options[:type].nil? && options[:mods]
      #       @@token.get("api/v2/beatmaps/#{beatmap_id}/scores?mode=#{options[:mode]}&mods[]=#{options[:mods]}")
      #     when options[:mode] && options[:type].nil? && options[:mods].nil?
      #       @@token.get("api/v2/beatmaps/#{beatmap_id}/scores?mode=#{options[:mode]}")
      #     when options[:mode] && options[:type] && options[:mods]
      #       @@token.get("api/v2/beatmaps/#{beatmap_id}/scores?mode=#{options[:mode]}&type=#{options[:type]}&mods[]=#{options[:mods]}")
      #   end

      #   @@token.get("api/v2/beatmaps/#{beatmap_id}/scores")
      # end
      def getBeatmapScores(beatmap_id, mode: nil, mods: nil, type: nil)
        if mods.present? && @@is_supporter
          @@token.get("api/v2/beatmaps/#{beatmap_id}/scores?mode=#{mode}&type=#{type}&mods[]=#{mods}")
        elsif mods.present? && !@@is_supporter
          raise "You can't specifiy mods since you do not have osu!supporter"
        else
          @@token.get("api/v2/beatmaps/#{beatmap_id}/scores?mode=#{mode}&type=#{type}&mods[]=#{mods}")
        end
      end
      def getBeatmaps(*beatmaps) # "api/v2/beatmaps?ids[]=12345&ids[]=45678&ids[]=8934939"
        beatmaps_query = createQuery("ids[]=", beatmaps)
        @@token.get("api/v2/beatmaps?#{beatmaps_query}").parsed
      end

      def getBeatmap(beatmap_id) # https://osu.ppy.sh/beatmapsets/39804#osu/129891  (129891 gonna be the ID cuz its a beatmapset)
        @@token.get("api/v2/beatmaps/#{beatmap_id}").parsed
      end


      def getForumpost(forumpost_id, cursor_string: nil, sort: nil, limit: nil, start: nil, end: nil)
        @@token.get("api/v2/forums/topics/#{forumpost_id}?cursor_string=#{cursor_string}&sort=#{sort}&limit=#{limit}&start=#{start}&end=#{end}").parsed
      end
                                        
      def getMatch(match_id)
        @@token.get("api/v2/matches/#{match_id}").parsed
      end
      

      def getRanking(mode, type, country: nil, cursor: nil, filter: all, spotlight: nil, variant: nil)
        @@token.get("api/v2/rankings/#{mode}/#{type}?country=#{country}&cursor=#{cursor}&filter=#{filter}&spotlight=#{spotlight}&variant=#{variant}")
      end

      def search(mode: all, query: nil, page: nil) # mode: all, user or wiki_page
        @@token.get("api/v2/search?mode#{mode}&query=#{query}&page=#{page}").parsed
      end
      def getMostRecentMatches(limit: 50) # 50 latest created matches
        @@token.get("api/v2/matches?limit=#{limit}")
      end

      def getSpotlights
        @@token.get("api/v2/spotlights")
      end

      def getBeatmapsetsEvents
        @@token.get("api/v2/beatmapsets/events").parsed
      end

      def getSeasonalBackgrounds
        @@token.get("api/v2/seasonal-backgrounds").parsed
      end
      # Remove after finished
      def api(uri)
        @@token.get(uri).parsed
      end

      private
      def createQuery(query, array)
        full_query = ""
        for x in array
          full_query = "#{full_query + query + x}&"
        end
        full_query = full_query[0..-2]
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
