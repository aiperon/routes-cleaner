require 'minitest/autorun'

class SniffersTest < Minitest::Test

  def test_normalize
    unzipped_data = Normalizer.unzip_data('sniffers', './test/data/sniffers.zip')

    routes = Normalizer::Sniffers.normalize(unzipped_data)

    assert_equal 2, routes.count
  end

end