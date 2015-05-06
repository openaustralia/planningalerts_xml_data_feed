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
    "#{ENV["API_ENDPOINT"]}?key=#{ENV["API_KEY"]}&date_scraped=#{date_scraped}"
  end

  def applications_on_date(date)
    JSON.parse(open(api_url(date)).read)
  end

  def applications_on_date_as_xml(date)
    # TODO: Format XML correctly
    applications_on_date(date).to_xml
  end
end
