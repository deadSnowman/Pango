#!/usr/bin/ruby
# encoding: utf-8

def da message
  m = message.message.to_s.downcase
  flist = JSON.parse(IO.read("acdata.json"))
  m = m[/(\?da[ ]).*/]
  if(m)
    begin
      message.reply flist[m.gsub("?da ","")]["da"].to_s
    rescue Exception => e
      puts e.message
    end
  end
end
