require 'minitest/autorun'

class SentinelsTest < Minitest::Test

  def test_normalize
    unzipped_data = Normalizer.unzip_data('sentinels', './data/sentinels.zip')

    routes = Normalizer::Sentinels.normalize(unzipped_data)

    assert_equal routes.count, 2
  end

end