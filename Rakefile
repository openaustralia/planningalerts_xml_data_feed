require_relative "xml_data_feed"

# Show all applications for a calendar week as XML. Shoud only be needed for debugging.
task :applications, :date do |t, args|
  puts XmlDataFeed.new(date: args.date).calendar_week_applications
end

desc "SFTP applications for a calendar week as XML"
task :transfer_applications, :date do |t, args|
  XmlDataFeed.new(date: args.date).transfer_applications
end
