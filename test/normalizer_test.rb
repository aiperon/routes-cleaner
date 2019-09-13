require 'minitest/autorun'

class NormalizerTest < Minitest::Test

  def test_all_sources
    sources = Normalizer.all_sources

    assert_includes sources.keys, 'sentinels'
    assert_includes sources.keys, 'sniffers'
    assert_includes sources.keys, 'loopholes'
  end

  def test_process_source
    fake_gate = MiniTest::Mock.new

    fake_source = 'dummy'
    fake_response = {}
    fake_gate.expect :dirty_routes, fake_response, [ fake_source ]
    fake_gate.expect :send_back!, {}, [ fake_source, [] ]

    fake_parser = MiniTest::Mock.new
    fake_parser.expect :parse, [], [ fake_response ]

    assert Normalizer.process_source(fake_gate, fake_source, fake_parser)
  end
end