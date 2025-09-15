#!/usr/bin/ruby
# frozen_string_literal: true

require 'discord_notifier'
require 'date'
require 'ferrum'
require 'dotenv'
require 'set'
Dotenv.load


def return_accessor_from_ARGV(args)
  accessor_argv_index = ARGV.find_index"-id"
  raise "You must specify accessor using ./schedule_notifier -id [ID]" unless accessor_argv_index
  
  accessor = ARGV[accessor_argv_index+1]
  raise "You must specify an ID after -id" unless accessor

  return accessor.to_i
end

def get_planning(user, file_name="schedule")
  browser = Ferrum::Browser.new()
  browser.go_to("https://extra.u-picardie.fr/calendar/Login")

  browser.at_css("input#username").focus.type(user[:login])
  browser.at_css("input#password").focus.type(user[:password])
  browser.at_css("button[type='submit']").focus.click
  browser.network.wait_for_idle
  sleep(2)
  browser.at_css(".fc-agendaWeek-button").focus.click
  browser.at_css(".fc-next-button.fc-button.fc-state-default.fc-corner-right").focus.click if Time.now.sunday?
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

  browser.screenshot(path: "#{file_name}.png",selector: "#calendar")
  # browser.screenshot(path: "schedule2.png", full: true)
  # You´d think a full-page screenshot would be better. . . .
  browser.quit
end

def send_image_to_user(user, file_name="schedule")

  Discord::Notifier.setup do |config|
      config.url = user[:webhook_url]
      config.username = 'Schedule'
      config.wait = true
  end

  schedule_image = File.open("#{file_name}.png")
  date_today = Date.today.strftime('%a %d %b %Y') 
  Discord::Notifier.message(schedule_image, content: "Today is #{date_today} and here is the planning for this week!")
end


def notify_all_students(students)
  for student in students
    next if student[:webhook_url].nil? || student[:webhook_url].empty?

    p student[:login]
    get_planning(student)
    send_planning_to_user(student) unless is_dry
  end
end



students = [
  {:login => ENV["LOGIN"], :password => ENV['PASSWORD'], :webhook_url => ENV["WEBHOOK"] ,:access => [1,2, 350283068046704641]},
  {:login => "bsd", :password => "", :webhook_url => "", :access => [3]}
]



is_daily_run = ARGV.to_set.include?"-daily"
is_dry = ARGV.to_set.include?"-dry"

if is_daily_run
  notify_all_students(students)  
  return
end

current_accessor = return_accessor_from_ARGV(ARGV)

accessors_with_index = students.each_with_index.map { |el, index| [ el[:access], index ] }
all_accessors = students.map{ |s| s[:access] }.flatten.to_set




# Should I raise this?
raise "User id doesn't match with accessors list" unless all_accessors.include? current_accessor

def find_user_from_list_using_sublist(user, list, students)
  # We only keep the first for now. We want it's index.
  current_user_index = list.reject{ |acc| !acc[0].include?user }.first[1]
  students[current_user_index]
end

current_user = find_user_from_list_using_sublist(current_accessor, accessors_with_index, students)
get_planning(current_user, file_name=current_accessor)