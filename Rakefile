require_relative "xml_data_feed"
require "active_support"
require "active_support/core_ext/date"
require "active_support/core_ext/numeric"

# Show all applications for a calendar week as XML. Shoud only be needed for debugging.
task :applications, :date do |t, args|
  puts XmlDataFeed.new(date: args.date).calendar_week_applications
end

desc "SFTP weekly PlanningAlerts XML files (to_date is optional)"
task :transfer_applications, [:from_date, :to_date] do |t, args|
  if !args.to_date.nil?
    from_date, to_date = Date.parse(args.from_date), Date.parse(args.to_date)
    date = from_date
    while date < to_date
      XmlDataFeed.new(date: date.to_s).transfer_applications
      date = date + 1.week
    end
  else
    XmlDataFeed.new(date: args.from_date).transfer_applications
  end
end
