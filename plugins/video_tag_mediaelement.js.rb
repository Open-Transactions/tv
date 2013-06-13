# Title: Simple Video tag for Jekyll
# Author: Brandon Mathis http://brandonmathis.com
# Description: Easily output MPEG4 HTML5 video with a flash backup.
#
# Syntax {% video url/to/video [width height] [url/to/poster] %}
#
# Example:
# {% video http://site.com/video.mp4 720 480 http://site.com/poster-frame.jpg %}
#
# Output:
# <video width='720' height='480' preload='none' controls poster='http://site.com/poster-frame.jpg'>
#   <source src='http://site.com/video.mp4' type='video/mp4; codecs=\"avc1.42E01E, mp4a.40.2\"'/>
# </video>
#

module Jekyll

  class VideoTagMe < Liquid::Tag
    @video = nil
    @poster = ''
    @height = ''
    @width = ''

    def initialize(tag_name, markup, tokens)
      if markup =~ /((https?:\/\/|\/)(\S+))(\s+(\d+)\s(\d+))?(\s+(https?:\/\/|\/)(\S+))?/i
        @video  = $1
        @width  = $5
        @height = $6
        @poster = $7
      end
      super
    end

    def render(context)
      output = super
      if @video
        #video =  "<video width='#{@width}' height='#{@height}' preload='none' controls poster='#{@poster}'>"
        #video += "<source src='#{@video}' type='video/mp4; codecs=\"avc1.42E01E, mp4a.40.2\"'/></video>"

        video = <<GROCERY_LIST
<video width="#{@width}" height="#{@height}" poster="poster.jpg" controls="controls" preload="none">
    <!-- MP4 for Safari, IE9, iPhone, iPad, Android, and Windows Phone 7 -->
    <source type="video/mp4" src="#{@video}" />
    <!-- WebM/VP8 for Firefox4, Opera, and Chrome -->
    <source type="video/webm" src="#{@video}" />
    <!-- Ogg/Vorbis for older Firefox and Opera versions -->
    <source type="video/ogg" src="#{@video}" />
    <!-- Optional: Add subtitles for each language -->
    <track kind="subtitles" src="subtitles.srt" srclang="en" />
    <!-- Optional: Add chapters -->
    <track kind="chapters" src="chapters.srt" srclang="en" />
    <!-- Flash fallback for non-HTML5 browsers without JavaScript -->
    <object width="#{@width}" height="#{@height}" type="application/x-shockwave-flash" data="flashmediaelement.swf">
        <param name="movie" value="flashmediaelement.swf" />
        <param name="flashvars" value="controls=true&file=#{@video}" />
        <!-- Image as a last resort -->
        <img src="myvideo.jpg" width="320" height="240" title="No video playback capabilities" />
    </object>
</video>


<script>
// using jQuery
jQuery('video,audio').mediaelementplayer(/* Options */);
</script>
GROCERY_LIST

      else
        "Error processing input, expected syntax: {% video url/to/video [width height] [url/to/poster] %}"
      end
    end
  end
end

Liquid::Template.register_tag('video_me', Jekyll::VideoTagMe)

