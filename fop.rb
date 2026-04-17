#!/usr/bin/ruby
# frozen_string_literal: true

require 'discord_notifier'
require 'net/http'
require 'json'
require 'dotenv'
Dotenv.load

Discord::Notifier.setup do |config|
    config.url = ENV["WEBHOOK"]
    config.username = 'Hourly fox'
    config.wait = true
end

uri = URI 'https://randomfox.ca/floof/'
res = Net::HTTP.get_response uri

if res.is_a? Net::HTTPSuccess
    res_json = JSON.parse(res.body)
    Discord::Notifier.message(res_json.fetch("image"), content: "Your hourly fox!")
else
    Discord::Notifier.message(content: "No fox at this hour :c")
end

