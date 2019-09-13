
module Normalizer

  class << self

    def all_sources
      {
        'sentinels' => Sentinels,
        'sniffers' => Sniffers,
        'loopholes' => Loopholes
      }
    end

    def process(gate)
      all_sources.each do |source, klass|
        process_source(gate, source, klass)
      end
    end

    def process_source(gate, source, klass)
      puts "Analyzing `#{source}` source…"
      response = gate.dirty_routes(source)

      data = klass.parse(response)

      puts "Collected #{data.length} routes"
      gate.send_back!(source, data)
    end

  end
end