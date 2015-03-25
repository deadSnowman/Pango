#!/usr/bin/ruby
# encoding: utf-8

require 'cinch'
require_relative './plugins/fc.rb'
require_relative './plugins/da.rb'
require_relative './plugins/inf.rb'
require_relative './plugins/villager.rb'
require_relative './plugins/youtube.rb'
require_relative './plugins/update.rb'
require_relative './plugins/mo.rb'
require_relative './plugins/hello.rb' #plugins don't work currently

class Pango
  def initialize(nick, passwd, server, chan, port, logDir)
    @nick = nick
    @passwd = passwd
    @server = server
    @chan = chan
    @port = port
    @logDir = logDir
  end

  def findChan(chan)
    ch = Array.new
    chan.each_with_index do |item, index|
      ch.push(index)
      puts "added " + item.to_s + " to channel list"
    end
  end
  def findNick(nick)
    return nick
  end
  def findServ(server)
    return server
  end
  def findPass(passwd)
    return passwd
  end

  def start
    #stupid fix for instance variables not being in the scope
    ch = findChan(@chan)
    n = findNick(@nick)
    srv = findServ(@server)
    pswd = findPass(@passwd)

    bot = Cinch::Bot.new do
      configure do |c|
        c.nick = n
        c.server = srv
        c.channels = ch
        c.password = pswd
        #c.plugins.plugins = [Hello] #plugins don't work
      end

      #on :message, "hello" do |m|
      #  m.reply "Hello, #{m.user.nick}"
      #end
      
      on :message, /[\?fc]/ do |mess|
        fc(mess)
      end

      on :message, /[\?da]/ do |mess|
        da(mess)
      end

      on :message, /[\?info]/ do |mess|
        inf(mess)
      end

      on :message, /[\?villager]/ do |mess|
        villager(mess)
      end

      #parse method executes on ?fc... etc
      on :message, /[youtube.com\/watch\?v=.*|youtu\.be\/]/ do |mess|
        youtube(mess)
      end

      #executes on ?fc and ?info... etc
      on :message, /[\?update]/ do |mess|
        update(mess)
      end

      on :connect do |m|
        mo("#adoptmyvillager")
        #my_channel = "#Pangotesting"
        #Channel(my_channel).send
      end

      #=====GITHUB CODE=====
      $admin = "deadSnowman"

      helpers do
        def is_admin?(user)
          true if user.nick == $admin
        end
      end

      on :message, /^?join (.+)/ do |m, channel|
        bot.join(channel) if is_admin?(m.user)
      end

      on :message, /^?part(?: (.+))?/ do |m, channel|
        # Part current channel if none is given
        channel = channel || m.channel

        if channel
          bot.part(channel) if is_admin?(m.user)
        end
      end
      #=====================

    end

    bot.start
  end

end #end class

