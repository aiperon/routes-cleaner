#require 'httparty'

class Gate
  AUTH_URL = "https://challenge.distribusion.com/the_one"
  DATA_URL = 'https://challenge.distribusion.com/the_one/routes'

  attr_reader :passphrase

  def initialize(*args)
    @passphrase = get_passphrase()
  end

  def get_passphrase
    response = HTTParty.get(AUTH_URL, headers: {'Accept' => 'application/json'})

    begin
      passphrase = JSON.parse(response.body).dig('pills', 'red', 'passphrase')
    rescue JSON::ParserError => e
      puts "#{e.message}\nTry again Neo…"
    end

    passphrase
  end

  def dirty_routes(source)
    HTTParty.get(DATA_URL, query: {
      passphrase: @passphrase,
      source: source
    })
  end

  def send_back!(source, parsed_data)
    parsed_data.each do |route|
      %i(start_time end_time).each do |field|
        route[field] = route[field].utc.iso8601.gsub(/Z\z/, '')
      end

      response = HTTParty.post(DATA_URL, body: route.merge(
        passphrase: @passphrase,
        source: source
      ))
      puts response.body
    end
  end

end

