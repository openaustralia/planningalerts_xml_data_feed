require_relative "xml_data_feed"

desc "Show all applications for a calendar week as XML"
task :applications, :date do |t, args|
  puts XmlDataFeed.new.calendar_week_applications(args.date)
end

desc "SFTP applications for a calendar week as XML"
task :transfer_applications, :date do |t, args|
  puts XmlDataFeed.new.transfer_applications(args.date)
end
