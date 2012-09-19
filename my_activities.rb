#!/usr/bin/env ruby

require 'rubygems'
require 'github_api'
require 'pry'
require 'time'

module Helpers
  def self.handle_GistEvent(current_event)
    puts "GIST CREATED: <#{current_event.payload.gist.html_url}> (#{current_event.payload.gist.description})"
  end

  def self.handle_PushEvent(current_event)

    puts "PUSHed code: <https://github.com/#{current_event.repo.name}>"
    puts "See diff: https://github.com/#{current_event.repo.name}/compare/#{current_event.payload.before}...#{current_event.payload.head}"
  end
end

def main
  username = ENV["GITHUB_USERNAME"]
  password = ENV["GITHUB_PASSWORD"]

  raise "MUST set GITHUB_USERNAME environmental variable" unless username
  raise "MUST set GITHUB_PASSWORD environmental variable" unless password

  github = Github.new :login => username, :password => password

  events = github.events.performed username #will return private events also since we are logged in

  events.each do |current_event|
   #
    if Helpers.respond_to? "handle_#{current_event.type}"
      Helpers.__send__ "handle_#{current_event.type}", current_event
    else
      puts "#{current_event.type} IN REPO <https://github.com/#{current_event.repo.name}>"
    end
      puts "    on #{Time.iso8601(current_event.created_at).localtime}"
      puts
  end
end

main
