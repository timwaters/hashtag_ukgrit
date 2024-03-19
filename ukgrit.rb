# Welcome in Rash.
# http://github.com/webs/rash - released under the MIT licence
%w(rubygems sinatra haml sass rfeedparser).each { |dependency| require dependency }

configure do
  Title = "#ukgrit - tracking the grit across the UK"
  Name = "#ukgrit"
  Tagline = "Grit Tracking!"
  Hashtag = "ukgrit"
  TwitterSearchUrl = "http://search.twitter.com/search.atom?q=%23"
  Footer = "tim_waters"
  set_option :haml, :format => :html4
end
 
get '/' do
  header 'Content-Type' => 'text/html; charset=utf-8'
  tag = params[:tag] || Hashtag
  @introduction = "Welcome! To display your tweets here, 
  just put the <a href='http://hashtags.org/'>hashtag</a> <strong>##{tag}</strong> 
  followed by the first bit of your postcode, followed by a number out of 10, i.e. <strong>#ukgrit LS12 7/10</strong>
  <br />0 = Death by ice. No grit here, cars and people sliding around. 10 = surfaces like a dry (salty) summer day, grip is strong. So, the scale is an indication of the observed results of the amount of grit laid. <br />"
  pf = FeedParser.parse(TwitterSearchUrl + tag)
  @entries = pf.entries
  haml :home
end

get '/rash.css' do
  header 'Content-Type' => 'text/css; charset=utf-8'
  sass :stylesheet
end

use_in_file_templates!

__END__
@@ layout
!!! strict
%html
  %head
    %title= Title
    %link{:rel => 'stylesheet', :href => '/rash.css', :type => 'text/css'}
  %body
    #container
      #head
        %span.title= Name
        %span.subtitle= Tagline
      .intro
        %p
          = @introduction
          %br
      = yield
      #footer
        %a{:href => 'http://twitter.com/tim_waters', :title => 'follow Tim'}="Follow Tim" 
     
        %p
          Map coming soon!
      %br/
      %img{:src=>'http://search.twitter.com/images/powered-by-twitter-sig.gif?1216137693', :title => 'Powered by Twitter!'}
      %a{:href=>'http://github.com/webs/rash'}= "and rash"

@@ home
- for entry in @entries
  - next if entry['title'].match( /\d+\/\d+/ ).nil?
  .twit
    - url_pattern = /(http[s]?:\/\/[-\w\.]+[\d+]?[\/\w\/_\.\~]*[\?\S+]?)/
    - entry['title'].gsub!(url_pattern, '<a class="url" href="\1">\1</a>')
    - entry['title'].gsub!(/\#(\w+)/, '<a class="hashtag" href="/?tag=\1">#\1</a>')
    %p= entry['title']
    %span
      ^- from
      %a{:href=>entry['href']}= entry['author']
      on
      - nicetime = Time.parse(entry['published_time'].to_s).strftime('%d/%m/%Y at %H:%M:%S')
      %a{:href=>entry['link']}= nicetime


@@ stylesheet
html
  :background #000000 url(http://oseflol.com/images/bg_twitter_black.gif) fixed no-repeat top left
  :color #000
  :font-family Helvetica Neue, Helvetica, Arial, sans-serif
  :padding 0em


body
  :margin-left 2.6em
  :margin-top 1.8em
  :margin-bottom 1em
  :margin-right 1em
  :line-height 1.4em
  :font-size .9em


#container
  :width 755px
  :margin 0 auto
  :padding 15px 0
  :text-align left
  :position relative


#head
  :top 0px
  :position fixed
  :padding 10px
  :padding-top 25px
  :background-color #202020
  :opacity 0.98
  :width 755px

  .title
    :font-size 70px
    :font-weight bold
    :color white
    :margin 0
    :padding 0


.subtitle
  :color white
  :font-size 18px


.intro
  :margin-top 40px
  :color white

  a
    :color white

#footer
  :color yellow
.footer
  :margin-top 10px
  :font-size 10px
  :color grey

  a
    :color white
  p
    :color white

.twit
  :margin-top 20px
  :margin-bottom 20px
  :padding 10px

  p
    :font-size 30px
    :color white
    :font-weight bold
    :line-height 1.1em
    :margin 0
    :margin-bottom 5px

  span
    :font-size 18px
    :color white
    a
      :color white

.hashtag
  :border-bottom 1px dashed #fff
  :color #777
  :text-decoration none

.url
  :border-bottom 1px dashed #fff
  :color #aaa
  :text-decoration none
