require_relative "bulk_api_transferrer"

desc "Show all applications for a date as XML"
task :applications, :date do |t, args|
  puts BulkApiTransferrer.new.applications_on_date_as_xml(args.date)
end

desc "Show all applications for a calendar week as XML"
task :applications_week, :date do |t, args|
  puts BulkApiTransferrer.new.calendar_week_applications(args.date)
end
