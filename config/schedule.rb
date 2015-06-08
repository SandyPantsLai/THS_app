# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
every :day, at: '12am' do
  rake 'holds:update_hold_queue'
end

every :day, at: '1am' do
  rake 'check_outs:send_overdue_email'
end

every :day, at: '2am' do
  rake 'deposits:create_top_up_transaction'
end

every '0 2 05 * *' do
  # runs monthly at 2am on the 5th of the month
  rake 'member_fees:deactivate_users'
end