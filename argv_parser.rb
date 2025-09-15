require 'set'
# We use set for performance reasons. 
# Also prevents duplicate which should not matter in our use case. This is subject to change


# Takes ARGV, either raises an error if there's an issue with the ID or returns said ID.
# The user MUST input an ID if it's not a daily run.
def return_accessor_from_ARGV(args)
  accessor_argv_index = args.find_index"-id"
  raise "ERROR : Daily run isn't initialized. Specify user's id using -id [ID]" unless accessor_argv_index
  accessor = args[accessor_argv_index+1]
  raise "ERROR : You must specify an ID after -id" unless accessor
  return accessor.to_i
end

def parse_args(argv)
    is_dry = argv.to_set.include?"-dry"
    is_daily_run = ARGV.to_set.include?"-daily"
    current_user = is_daily_run ? nil : return_accessor_from_ARGV(argv)
    return :is_dry => is_dry, :is_daily_run => is_daily_run, :current_user => current_user    
end
