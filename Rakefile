require_relative "xml_data_feed"

desc "Show all applications for a date as XML"
task :applications, :date do |t, args|
  puts XmlDataFeed.new.applications_on_date_as_xml(args.date)
end

desc "Show all applications for a calendar week as XML"
task :applications_week, :date do |t, args|
  puts XmlDataFeed.new.calendar_week_applications(args.date)
end
