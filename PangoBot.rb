#!/usr/bin/ruby
# encoding: utf-8

require 'rubygems'
require 'cgi'
require 'open-uri'
require 'openssl'
require 'fileutils'
require 'json'
require 'google_drive'

require './lib/PangoLib'

#esperBot = Pango.new("Pango", "whyisaspatula", "irc.esper.net", ["#Pangotesting", "#adoptmyvillager", "#animalcrossing", "#ac-afterdark", "#actrade"], 6667, "/home/seth/ircstuff/irclogs");

esperBot = Pango.new("Pango", "whyisaspatula", "irc.rizon.net", ["#Pangotesting"], 6667, "/home/seth/ircstuff/irclogs");



esperBot.start;
