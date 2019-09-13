require 'minitest/autorun'
require 'webmock/minitest'

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

    fake_normalizer = MiniTest::Mock.new
    fake_normalizer.expect :normalize, [], [ fake_response ]

    assert_nil Normalizer.process_source(fake_gate, fake_source, fake_normalizer)
  end

  def test_save_archive_empty_content
    fake_response = MiniTest::Mock.new
    assert_nil Normalizer.save_archive('dummy', fake_response)
  end

  def test_save_archive_unallowed_content
    fake_response = MiniTest::Mock.new
    fake_response.expect :headers, { 'content-type' => ['text/html'] }
    assert_nil Normalizer.save_archive('dummy', fake_response)
  end

  def test_save_archive_empty_archive
    fake_response = MiniTest::Mock.new
    fake_response.expect :headers, { 'content-type' => ['application/zip'] }
    fake_response.expect :body, ''

    assert_nil Normalizer.save_archive('dummy', fake_response)
  end

  def test_save_archive_some

    fake_response = MiniTest::Mock.new
    fake_response.expect :headers, { 'content-type' => ['application/zip'] }
    fake_response.expect :body, 'some content'

    filename = File.join('.', 'data', 'dummy.zip')
    assert Normalizer.save_archive('dummy', fake_response) == filename
  end

end