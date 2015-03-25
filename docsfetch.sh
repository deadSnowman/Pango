#!/bin/bash

#load rvm ruby
source /home/seth/.rvm/environments/ruby-1.9.3-p194
gem install google_drive
bundle install 

ruby docsfetch.rb
