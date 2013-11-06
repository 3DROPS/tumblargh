module Tumblargh
  module Renderer
    module Blocks
      class Audio < Post

        def audio_player(color=:default)
          html = context.player

          return html if color == :default

          map = { :white => 'FFFFFF', :grey => 'CCCCCC', :black => '000000' }
          color = map[color] unless map[color].nil?

          html.gsub(/color=[A-Z]{6}/i, "color=#{color}")
        end

        def audio_player_white
          audio_player(:white)
        end

        def audio_player_grey
          audio_player(:grey)
        end

        def audio_player_black
          audio_player(:black)
        end

        def audio_embed(size)
          player = context.player
          if player.include? "assets.tumblr"
            '<iframe class="tumblr_audio_player tumblr_audio_player_64979372506" src="http://posttypes.tumblr.com/post/64979372506/audio_player_iframe/posttypes/tumblr_mv6w8yzi521sm9w1y?audio_file=http%3A%2F%2Fwww.tumblr.com%2Faudio_file%2Fposttypes%2F64979372506%2Ftumblr_mv6w8yzi521sm9w1y&amp;color=white" frameborder="0" allowtransparency="true" scrolling="no" width="640" height="169" style="-webkit-transform: translate3d(0px, 0px, 0px);"></iframe>'
          else
            player
          end
        end

        # def raw_audio_url
        #   context.player.match(/audio_file=([^&]+)/)[1] rescue nil
        # end

        contextual_tag :raw_audio_url, :audio_url
        contextual_tag :play_count, :plays

        # TODO
        def formatted_play_count
          play_count.to_s.reverse.scan(/.{1,3}/).join(',').reverse
        end

        def play_count_with_label
          num = formatted_play_count
          "#{num} play#{num == 1 ? '' : 's'}"
        end

      end

      class AlbumArt < Base
        should_render_unless_blank :album_art_url
        contextual_tag :album_art_url, :album_art
      end

      class Artist < Base
        should_render_unless_blank :artist
        contextual_tag :artist
      end

      class Album < Base
        should_render_unless_blank :album
        contextual_tag :album
      end

      class TrackName < Base
        should_render_unless_blank :track_name
        contextual_tag :track_name
      end

      class AudioEmbed < Base
      end

      class AudioPlayer < Base
      end

    end
  end
end
