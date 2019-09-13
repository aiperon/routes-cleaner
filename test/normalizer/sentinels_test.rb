require 'minitest/autorun'
require 'minitest/mock'

class SentinelsTest < Minitest::Test

  def test_parse_empty_content
    fake_response = MiniTest::Mock.new
    assert_empty Normalizer::Sentinels.parse(fake_response)
  end

  def test_parse_unallowed_content
    fake_response = MiniTest::Mock.new
    fake_response.expect :headers, { 'content-type' => ['text/html'] }
    assert_empty Normalizer::Sentinels.parse(fake_response)
  end

  def test_parse_empty_archive
    fake_response = MiniTest::Mock.new
    fake_response.expect :headers, { 'content-type' => ['application/zip'] }
    fake_response.expect :body, ''

    klass = Normalizer::Sentinels
    mock_unzip(klass, [])

    assert_empty klass.parse(fake_response)
  end

  def test_parse_real_archive
    response = MiniTest::Mock.new
    response.expect :headers, { 'content-type' => ['application/zip'] }
    response.expect :body, File.read(File.join(__dir__, '..', '..', 'data', 'sentinels.zip'))

    data = Normalizer::Sentinels.parse(response)
    assert data.count, 2
  end


  def mock_unzip(klass, content)
    fake_method = MiniTest::Mock.new
    fake_method.expect :call, []
    klass.stub :unzip_data, fake_method do
      content
    end
  end

end