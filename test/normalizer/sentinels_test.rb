require 'minitest/autorun'

class SentinelsTest < Minitest::Test

  def test_normalize
    unzipped_data = Normalizer.unzip_data('sentinels', './test/data/sentinels.zip')

    routes = Normalizer::Sentinels.normalize(unzipped_data)

    assert_equal 2, routes.count
  end

end