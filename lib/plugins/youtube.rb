#!/usr/bin/ruby
# encoding: utf-8

# Parse youtube url
def parse_youtube url
  regex = /^(?:http:\/\/)?(?:www\.)?\w*\.\w*\/(?:watch\?v=)?((?:p\/)?[\w\-]+)/
    url.match(regex)[1]
end


def youtube message
  if(message.message =~ /https/)
    m = URI.extract(message.message, "https")[0]
    vid = parse_youtube m.gsub(/https/, "http")
  else
    m = URI.extract(message.message, "http")[0]
    vid = parse_youtube m
  end

  begin
    source = open("https://gdata.youtube.com/feeds/api/videos/" + vid + "?v=2&alt=json", :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read
    result = JSON.parse(source)
    message.reply "1,0You0,4Tube - " + result["entry"]["title"]["$t"].to_s + ", " + result["entry"]["author"][0]["name"]["$t"].to_s
  rescue => e
    case e
    when OpenURI::HTTPError
      puts "HTTP error"
      puts "Probably invalid video"
    when SocketError
      puts "Socket error"
    else
      raise e
    end
  end
end

