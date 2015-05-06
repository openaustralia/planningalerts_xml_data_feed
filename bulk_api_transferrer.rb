require "json"
require "open-uri"
require "active_support"
require "active_support/core_ext/array"
require "active_support/core_ext/hash"

class BulkApiTransferrer
  def initialize
    %w{API_ENDPOINT API_KEY}.each do |c|
      raise "Missing configuration: #{c}" if ENV[c].nil?
    end
  end

  def api_url(date_scraped)
    "#{ENV["API_ENDPOINT"]}?v=2&key=#{ENV["API_KEY"]}&date_scraped=#{date_scraped}"
  end

  def applications_on_date(date)
    # TODO: Handle multiple pages in response (i.e. > 1K results)
    JSON.parse(open(api_url(date)).read)["applications"]
  end

  def applications_on_date_as_xml(date)
    applications_on_date(date).to_xml(root: "applications", skip_types: true, dasherize: false)
  end

  # Returns all applications from the calendar week of the date specified as XML
  def calendar_week_applications(date_string)
    date = Date.parse(date_string)
    applications = []
    (start_of_week(date)...end_of_week(date)).each do |d|
      applications += applications_on_date(d)
    end
    applications.to_xml(root: "applications", skip_types: true, dasherize: false)
  end

  def start_of_week(date)
    date - (date.cwday - 1)
  end

  def end_of_week(date)
    date - (date.cwday - 7)
  end

  # TODO: Transfer (FTP?) results somewhere
end
