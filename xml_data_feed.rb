require "json"
require "open-uri"
require "active_support"
require "active_support/core_ext/array"
require "active_support/core_ext/hash"
require "active_support/core_ext/date"

class XmlDataFeed
  def initialize
    # TODO: Read these out of the .env-example
    %w{API_ENDPOINT API_KEY SFTP_HOST SFTP_USERNAME SFTP_PASSWORD}.each do |c|
      raise "Missing configuration: #{c}" if ENV[c].nil?
    end
  end

  def api_url(date_scraped)
    "#{ENV["API_ENDPOINT"]}?v=2&key=#{ENV["API_KEY"]}&date_scraped=#{date_scraped}"
  end

  def applications_on_date(date)
    # TODO: Handle multiple pages in response (i.e. > 1K results)
    JSON.parse(open(api_url(date)).read)["applications"].map { |a| a["application"] }
  end

  def applications_on_date_as_xml(date)
    as_xml applications_on_date(date)
  end

  # Returns all applications from the calendar week of the date specified as XML
  def calendar_week_applications(date_string)
    date = Date.parse(date_string)
    applications = []
    (date.beginning_of_week...date.end_of_week).each do |d|
      applications += applications_on_date(d)
    end
    as_xml applications
  end

  def as_xml(applications)
    applications.to_xml(root: "applications", skip_types: true, dasherize: false)
  end

  # TODO: Transfer (FTP?) results somewhere
end
