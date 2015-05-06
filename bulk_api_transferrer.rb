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

  # TODO: Get all applications for a week
  # TODO: Transfer (FTP?) results somewhere
end
