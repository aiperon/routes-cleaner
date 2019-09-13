require 'minitest/autorun'

class LoopholesTest < Minitest::Test

  def test_normalize
    unzipped_data = Normalizer.unzip_data('loopholes', './test/data/loopholes.zip')

    routes = Normalizer::Loopholes.normalize(unzipped_data)

    assert_equal 2, routes.count
  end

end