#!/usr/bin/ruby
# frozen_string_literal: true

require 'discord_notifier'
require 'date'
require 'ferrum'
require 'dotenv'
Dotenv.load

Discord::Notifier.setup do |config|
    config.url = ENV["WEBHOOK"]
    config.username = 'Schedule'
    config.wait = true
  end

browser = Ferrum::Browser.new()
browser.go_to("https://extra.u-picardie.fr/calendar/Login")

browser.at_css("input#username").focus.type(ENV['LOGIN'])
browser.at_css("input#password").focus.type(ENV['PASSWORD'])
browser.at_css("button[type='submit']").focus.click
browser.network.wait_for_idle
sleep(2)
browser.at_css(".fc-agendaWeek-button").focus.click
# w h y does the page still load AFTER the network's gone idle?????????
browser.network.wait_for_idle
sleep(2)
# Bro, this is awful. Genuinely couldn't find a better way to get a clean screenshot. Awful shit.
browser.execute("
  document.querySelector('#calBrowseBarDiv').style.display = 'none';
  document.querySelector('.navbar.navbar-inverse.navbar-fixed-top').style.display = 'none';
  document.querySelector('#ctColourKey').style.display = 'none';
  document.querySelector('footer').style.display = 'none';  
")

browser.screenshot(path: "schedule.png",selector: "#calendar")
# browser.screenshot(path: "schedule2.png", full: true)
# You´d think a full-page screenshot would be better. . . .
browser.quit

schedule_image = File.open('schedule.png')
date_today = Date.today.strftime('%a %d %b %Y') 
Discord::Notifier.message(schedule_image, content: "Today is #{date_today} and here is the planning for this week!")