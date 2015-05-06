require_relative "bulk_api_transferrer"

desc "Show all applications for a date as XML"
task :applications, :date do |t, args|
  puts BulkApiTransferrer.new.applications_on_date(args.date)
end
