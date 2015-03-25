#!/usr/bin/ruby
# encoding: utf-8

def villager message
  m = message.message.to_s.downcase
  m2 = message.message.to_s
  m = m[/(\?villager[ ]).*/]
  if(m)
    begin
      message.reply "http://animalcrossing.wikia.com/wiki/" + m2.gsub("?villager ","").gsub(/\s+/, "_").strip.to_s
    rescue Exception => e
      puts e.message
    end
  end
end
