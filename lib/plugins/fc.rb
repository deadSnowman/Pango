#!/usr/bin/ruby
# encoding: utf-8

def fc message
  m = message.message.to_s.downcase
  flist = JSON.parse(IO.read("acdata.json"))
  m = m[/(\?fc[ ]).*/]
  if(m)
    begin
      message.reply flist[m.gsub("?fc ","")]["fc"].to_s
    rescue Exception => e
      puts e.message
    end
  end
end
