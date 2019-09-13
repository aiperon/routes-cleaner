#require 'httparty'

class Gate
  AUTH_URL = "https://challenge.distribusion.com/the_one"
  DATA_URL = 'https://challenge.distribusion.com/the_one/routes'

  attr_reader :passphrase

  def initialize(*args)
    @passphrase = get_passphrase() #'Kans4s-i$-g01ng-by3-bye'
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
    parsed_data.each do |route_details|
      response = HTTParty.post(DATA_URL, body: route_details.merge(
        passphrase: @passphrase,
        source: source
      ))
      puts response.body
    end
  end

end

