#!/usr/bin/ruby
# encoding: utf-8

require 'snoo'
require 'json'

def every(n)
  loop do
    before = Time.now
    yield
    interval = n - (Time.now - before)
    sleep(interval) if interval > 0
  end
end

def mo m

  my_channel = m

  # Create a new instance of the client
  reddit = Snoo::Client.new

  # Log into reddit
  reddit.log_in 'deadSnowman', 'whyisaspatula'

  # Check if the newest post is current
  current = ""
  every 3 do
    data = reddit.get_listing(subreddit: "adoptmyvillager", page: "new", sort: "new", limit: "1")['data']
    new = data["children"][0]["data"]["subreddit_id"]
    if new != current
      current = data["children"][0]["data"]["subreddit_id"]
      # Post if villager is moving out
      if data["children"][0]["data"]["title"] =~ /^\[MO\].*/
        Channel(my_channel).send data["children"][0]["data"]["title"] + " - by " + data["children"][0]["data"]["author"] + ", created at " + Time.at(data["children"][0]["data"]["created_utc"]).to_s + "UTC.  " + data["children"][0]["data"]["url"].to_s
      end
    end
  end

  # Log back out of reddit
  reddit.log_out
end
