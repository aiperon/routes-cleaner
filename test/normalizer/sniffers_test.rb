require 'minitest/autorun'

class SniffersTest < Minitest::Test

  def test_normalize
    unzipped_data = Normalizer.unzip_data('sniffers', './data/sniffers.zip')

    routes = Normalizer::Sniffers.normalize(unzipped_data)

    assert_equal routes.count, 2
  end

end