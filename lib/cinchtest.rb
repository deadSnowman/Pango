require 'cinch'

class Hello
  include Cinch::Plugin

  match /.*/

  def execute(m)
    m.reply "Hello, #{m.user.nick}"
  end
  
end

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.esper.net"
    c.channels = ["#Pangotesting"]
    c.plugins.plugins = [Hello]
  end

  #works
  #on :message, "hello" do |m|
  #  m.reply "Hello, #{m.user.nick}"
  #end
end

bot.start
