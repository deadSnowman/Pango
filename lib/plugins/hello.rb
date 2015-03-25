#!/usr/bin/ruby
# encoding: utf-8

class Hello
  include Cinch::Plugin

  match "hello"

  def execute(m)
    m.reply "Hello, #{m.user.nick}"
  end
  
end
