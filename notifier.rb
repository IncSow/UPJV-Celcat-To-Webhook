require_relative 'scrapper'
require 'discord_notifier'


def send_planning_to_user(user, file_name="schedule")

  Discord::Notifier.setup do |config|
      config.url = user[:webhook_url]
      config.username = 'Schedule'
      config.wait = true
  end

  schedule_image = File.open("#{file_name}.png")
  date_today = Date.today.strftime('%a %d %b %Y') 
  Discord::Notifier.message(schedule_image, content: "Today is #{date_today} and here is the planning for this week!")
end


def notify_all_students(is_dry_run)
  for student in $STUDENTS
    next if student[:webhook_url].nil? || student[:webhook_url].empty?
    get_planning(student)
    send_planning_to_user(student) unless is_dry_run
  end
end