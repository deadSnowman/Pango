#!/usr/bin/ruby
# encoding: utf-8

require 'rubygems'
require 'isaac'
#require 'isaac/bot'
require 'cgi'
require 'open-uri'
require 'openssl'
require 'fileutils'
require 'json'
require 'google_drive'

#adding for cinch
require 'cinch'

# Parse youtube url
def parse_youtube url
  regex = /^(?:http:\/\/)?(?:www\.)?\w*\.\w*\/(?:watch\?v=)?((?:p\/)?[\w\-]+)/
  url.match(regex)[1]
end

# Replace channel slashes for log
def repl_slashes chan
  chan.each_with_index do |item, index|
    chan[index].gsub(/\//, "_")
  end
end

# Log channel
def log channel, logdir
  FileUtils.mkdir_p "#{logdir}/#{repl_slashes channel}/"
  open("#{logdir}/#{repl_slashes channel}/#{repl_slashes channel}-" + Time.now.strftime("%Y-%m-%d") + ".log", "a") do |log|
    log.puts Time.now.strftime("[%H:%M]") + " <#{nick}> #{message}"
  end

  #display chat text
  puts Time.now.strftime("[%H:%M]") + " #{channel}: <#{nick}> #{message}"
end

# Display youtube title and author in chat
def youtube message
  if ( message =~ /youtube.com\/watch\?v=.*/ || message =~ /youtu\.be\//)
    #https
    if(message =~ /https/)
      m = URI.extract(message, "https")[0]
      vid = parse_youtube m.gsub(/https/, "http")
      puts vid
    else
      m = URI.extract(message, "http")[0]
      vid = parse_youtube m
      puts vid
    end
    begin
      source = open("https://gdata.youtube.com/feeds/api/videos/" + vid + "?v=2&alt=json", :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read
      result = JSON.parse(source)
      msg channel, "1,0You0,4Tube - " + result["entry"]["title"]["$t"].to_s + ", " + result["entry"]["author"][0]["name"]["$t"].to_s
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
end

def update message
  m = message.downcase
  if( m =~ /\?update/ )
    if(m)
      begin
        session = GoogleDrive.login("romanronin92@gmail.com", "Bugzilla92!!")
        ws = session.spreadsheet_by_key("15OytQnNhqAGWjE8Sn_JT1uPbUMaWFYsBI_lnd_F7vFc").worksheets[0]
        acData = Hash.new
        for row in 2..ws.num_rows
          acData[ws[row, 2].downcase] = { :villagername => ws[row, 3],
                                          :dsname => ws[row, 4],
                                          :townname => ws[row, 5],
                                          :fruit => ws[row, 6],
                                          :fc => ws[row, 7],
                                          :da => ws[row, 8],
                                          :timezone => ws[row, 9],
                                          :timezone2 => ws[row, 10],
                                          :notes => ws[row, 11],
                                          :ssheet => ws[row, 12]}
        end
        acData.store(:pango, { :fc => "snooooof"})
        File.open("acdata.json", "w"){ |file| file.write(JSON.pretty_generate(acData))}
        ws.reload()
        puts "ACdata updated"
        msg channel, "ACdata updated"
      rescue Exception => e
        puts e.message
      end
    end
  end
end

def fc message
  m = message.downcase
  flist = JSON.parse(IO.read("acdata.json"))
  if( m =~ /[\?fc]/ )
    m = m[/(\?fc[ ]).*/]
    if(m)
      begin
        puts flist[m.gsub("?fc ","")]["fc"]
        #msg channel, flist[m.gsub("?fc ","")]["fc"]
        m.reply flist[m.gsub("?fc ","")]["fc"]
      rescue Exception => e
        puts e.message
      end
    end
  end
end

def da message
  m = message.downcase
  flist = JSON.parse(IO.read("acdata.json"))
  if( m =~ /[\?da]/ )
    m = m[/(\?da[ ]).*/]
    if(m)
      begin
        puts flist[m.gsub("?da ","")]["da"]
        msg channel, flist[m.gsub("?da ","")]["da"]
      rescue Exception => e
        puts e.message
      end
    end
  end
end

def info message
  m = message.downcase
  flist = JSON.parse(IO.read("acdata.json"))
  if( m =~ /[\?info]/ )
    m = m[/(\?info[ ]).*/]
    if(m)
      begin
        puts flist[m.gsub("?info ","")]
        msg channel, "Villager " + flist[m.gsub("?info ","")]["villagername"] + ", " + 
          "3DS Name: " + flist[m.gsub("?info ","")]["dsname"] + ", " +
          "Town: " + flist[m.gsub("?info ","")]["townname"] + ", " +
          "Fruit: " + flist[m.gsub("?info ","")]["fruit"] + ", " +
          "Friend Code: " + flist[m.gsub("?info ","")]["fc"] + ", " +
          "Dream Address: " + flist[m.gsub("?info ","")]["da"] + ", " +
          "Timezone: " + flist[m.gsub("?info ","")]["timezone"] + ", " +
          "Timezone2: " + flist[m.gsub("?info ","")]["timezone2"] + ", " +
          "Notes: " + flist[m.gsub("?info ","")]["notes"] + ", " +
          "Personal Spread Sheet: " + flist[m.gsub("?info ","")]["ssheet"]

      rescue Exception => e
        puts e.message
      end
    end
  end
end

def villager message
  #m = message.downcase
  m = message
  if( m =~ /\?villager/ )
    m = m[/(\?villager[ ]).*/]
    if(m)
      m = m[/(\?villager[ ]).*/]
      msg channel, "http://animalcrossing.wikia.com/wiki/" + m.gsub("?villager ","").gsub(/\s+/, "_").strip
    end
  end
end

def miiverse message
  m = message.downcase
  if (m =~ /\?mii/ )
    m = m[/(\?mii[ ]).*/]
    if(m)
      m = m[/(\?mii[ ]).*/]
      msg channel, "https://miiverse.nintendo.net/users/" + m.gsub("?mii ","").gsub(/\s+/, "_").strip
    end
  end
end

def emoticon message
  m = message.downcase
  if( m =~ /(dongers|raise.*dongers)/ )
    msg channel, "ヽ༼ຈل͜ຈ༽ﾉ raise your dongers ヽ༼ຈل͜ຈ༽ﾉ"
  end
  if( m =~ /(flip(s|).*table|table.*flip(s|))/ )
    msg channel, "(╯°□°）╯︵ ┻━┻"
  end
end

def roll message
  m = message.downcase
  if( m =~ /\?(|\d{1,2})d(\d{1,}|)/ )
    times, die = m.match(/\?(|\d{1,})d(\d{1,}|)/).captures

    # default roll and die is one roll and 6 sided die
    if times == nil || times == ""
      times = "1"
    end
    if die == nil || die == ""
      die = "6"
    end

    result = "rolled: "
    i = 0
    while i < times.to_i
      if i == times.to_i - 1
        result = result + (Random.rand(die.to_i) + 1).to_s
      else
        result = result + (Random.rand(die.to_i) + 1).to_s + ", "
      end
      i = i+1
    end
    msg channel, result
  end
end
