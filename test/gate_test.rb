require 'minitest/autorun'
require 'webmock/minitest'

class GateTest < Minitest::Test

  def test_init_success
    stub_success_auth

    gate = Gate.new
    assert gate.passphrase != nil
  end

  def test_init_fail
    stub_request(:get, Gate::AUTH_URL).
      to_return(status: 406, body: "Not allowed")

    gate = Gate.new
    assert gate.passphrase.nil?
  end

  def test_dirty_routes
    stub_success_auth
    gate = Gate.new

    source = 'dummy'

    main_opts = {passphrase: gate.passphrase, source: source}
    stub_request(:get, Gate::DATA_URL).with(
      query: main_opts
    ).to_return(status: 200)#, headers: { 'Content-Type' => ['application/zip'] })

    routes = gate.dirty_routes(source)

    assert routes.class.name == 'HTTParty::Response'
  end

  def test_send_back!
    stub_success_auth
    gate = Gate.new

    source = 'dummy'
    data = [
      {one: 1},
      {two: 2},
      {three: 3},
    ]

    main_opts = {passphrase: gate.passphrase, source: source}

    stub_requests = []
    data.each do |opts|
      body = opts.merge(main_opts).to_a.map{|opt| opt.join('=') }.join('&')
      stub_requests << stub_request(:post, Gate::DATA_URL).with({body: body}).
        to_return(status: 200, body: "", headers: {})
    end

    gate.send_back!(source, data)

    stub_requests.each do |stub_request|
      assert_requested stub_request
    end
  end

private

  def stub_success_auth
    stub_request(:get, Gate::AUTH_URL).with(
      headers: { 'Accept'=>'application/json' }
    ).to_return(status: 200, body: {pills: {red: {passphrase: ''}}}.to_json)
  end
end