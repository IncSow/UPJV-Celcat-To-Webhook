#!/usr/bin/ruby
# frozen_string_literal: true

require 'dotenv'
require_relative 'scrapper'
require_relative 'argv_parser'
require_relative 'user'
require_relative 'notifier'
Dotenv.load


# Students contains a list of 'student'. They contain a login, password, webhook_url(optionnal) and an access key. 
# This access key corresponds to a list of discord ids that are able to run the planning.
# This implementation is mostly to go with my own bot and probably won't suit a single person's need.
$STUDENTS = [
  # LOVERS
  {:login => ENV["LOGIN1"], :password => ENV['PASSWORD1'], :webhook_url => ENV["WEBHOOK1"] ,:access => [154546717054730240, 350283068046704641]},
  # Anyone in group 21. Same as lovers.
  # {:login => ENV["LOGIN1"], :password => "ENV['PASSWORD1']", :webhook_url => ENV["WEBHOOK2"] ,:access => [595620436331462666]},
  # EDDYYYYYYYYYYYYYYYYY.
  {:login => ENV["LOGINEDDY"], :password => ENV['PASSWORDEDDY'], :access => [694116350703960084]}
]
begin
  args = parse_args(ARGV)

  if args[:is_daily_run]
    notify_all_students(args[:is_dry])
    return
  end

  student_index = get_current_user_access_index(args[:current_user])

  current_student = $STUDENTS[student_index]
  get_planning(current_student, args)

rescue RuntimeError => exception 
  p exception.message
  return
end
