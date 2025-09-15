#!/usr/bin/ruby
# frozen_string_literal: true

require 'dotenv'
require_relative 'scrapper'
require_relative 'argv_parser'
require_relative 'user'
require_relative 'notifier'
Dotenv.load
$STUDENTS = [
  {:login => ENV["LOGIN"], :password => "ENV['PASSWORD']", :webhook_url => ENV["WEBHOOK"] ,:access => [1,2, 350283068046704641]},
  {:login => "bsd", :password => "", :webhook_url => "", :access => [3]}
]
begin
  args = parse_args(ARGV)

  if args[:is_daily_run]
    notify_all_students
    return
  end

  student_index = get_current_user_access_index(args[:current_user])

  current_student = $STUDENTS[student_index]
  get_planning(current_student, args[:current_user])

rescue RuntimeError => exception 
  p exception.message
  return
end
