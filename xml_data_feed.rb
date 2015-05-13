require "json"
require "open-uri"
require "active_support"
require "active_support/core_ext/array"
require "active_support/core_ext/hash"
require "active_support/core_ext/date"
require "net/sftp"
require "stringio"

class XmlDataFeed
  def initialize(opts = {date: Date.today})
    @date = Date.parse opts[:date]
    # TODO: Read these out of the .env-example
    %w{API_ENDPOINT API_KEY SFTP_HOST SFTP_USERNAME SFTP_PASSWORD}.each do |c|
      raise "Missing configuration: #{c}" if ENV[c].nil?
    end
  end

  def api_url(date_scraped, page = 1)
    "#{ENV["API_ENDPOINT"]}?v=2&key=#{ENV["API_KEY"]}&date_scraped=#{date_scraped}&page=#{page}"
  end

  def applications_on_date(date)
    puts "Collecting applications for #{date}..."
    first_page = JSON.parse(open(api_url(date)).read)
    applications = first_page["applications"].map { |a| a["application"] }

    (first_page["page_count"] - 1).times do |t|
      page = t + 2
      puts "Page #{page}..."
      applications += JSON.parse(open(api_url(date, page)).read)["applications"].map { |a| a["application"] }
    end

    applications
  end

  # Returns all applications from the calendar week of the date specified as XML
  def calendar_week_applications
    puts "Collecting applications for #{@date.year}, week #{@date.cweek}..."
    applications = []
    (@date.beginning_of_week...@date.end_of_week).each do |d|
      applications += applications_on_date(d)
    end
    puts "Collected #{applications.count} applications."
    as_xml applications
  end

  def as_xml(applications)
    applications.to_xml(root: "applications", skip_types: true, dasherize: false)
  end

  def transfer_applications
    applications = calendar_week_applications

    puts "Connecting to #{ENV["SFTP_HOST"]}..."
    Net::SFTP.start(ENV["SFTP_HOST"], ENV["SFTP_USERNAME"], password: ENV["SFTP_PASSWORD"], port: (ENV["SFTP_PORT"] || 22)) do |sftp|
      # Ignore StatusException since it's also used when there's already a directory
      sftp.mkdir! "#{@date.year}" rescue Net::SFTP::StatusException

      puts "Uploading applications..."
      # Workaround NET::SFTP file.open not supporting upload of UTF-8
      io = StringIO.new(applications)
      sftp.upload!(io, "#{@date.year}/planningalerts_#{@date.year}-week#{@date.cweek}.xml")
      puts "Transfer complete."
    end
  end
end
