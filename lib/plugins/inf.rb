#!/usr/bin/ruby
# encoding: utf-8

def inf message
  m = message.message.to_s.downcase
  flist = JSON.parse(IO.read("acdata.json"))
  m = m[/(\?info[ ]).*/]
  if(m)
    begin
      #puts flist[m.gsub("?info ","")].to_s
      message.reply "Villager " + flist[m.gsub("?info ","")]["villagername"].to_s + ", " +
        "3DS Name: " + flist[m.gsub("?info ","")]["dsname"].to_s + ", " +
        "Town: " + flist[m.gsub("?info ","")]["townname"].to_s + ", " +
        "Fruit: " + flist[m.gsub("?info ","")]["fruit"].to_s + ", " +
        "Friend Code: " + flist[m.gsub("?info ","")]["fc"].to_s + ", " +
        "Dream Address: " + flist[m.gsub("?info ","")]["da"].to_s + ", " +
        "Timezone: " + flist[m.gsub("?info ","")]["timezone"].to_s + ", " +
        "Timezone2: " + flist[m.gsub("?info ","")]["timezone2"].to_s + ", " +
        "Notes: " + flist[m.gsub("?info ","")]["notes"].to_s + ", " +
        "Personal Spread Sheet: " + flist[m.gsub("?info ","")]["ssheet"].to_s
    rescue Exception => e
      puts e.message
    end
  end
end
