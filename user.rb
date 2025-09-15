# This might be the messiest file to date. The naming isn't the best, honestly.
# Unsure about SOC as well. . . . . .
def derive_authorized_access
  accessors_with_index = $STUDENTS.each_with_index.map { |el, index| [ el[:access], index ] }
  all_accessors = $STUDENTS.map{ |s| s[:access] }.flatten.to_set  
  return :authorized_list => accessors_with_index, :allowed_accessor_set => all_accessors
end


def find_logs_index_using_id(user_id, list)
  # We only keep the first for now. A user shouldn't have more than one set of logs
  current_user_index = list.reject{ |el| !el[0].include?user_id }.first[1]
end


def get_current_user_access_index(current_user)
  access_list = derive_authorized_access
  raise "NOT FOUND : User id can't be found in authorized list" unless access_list[:allowed_accessor_set].include? current_user
  find_logs_index_using_id(current_user, access_list[:authorized_list])
end
