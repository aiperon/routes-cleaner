require 'fileutils'

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
      puts "Normalizing `#{source}` source…"

      response = gate.dirty_routes(source)
      filename = save_archive(source, response)

      return if !filename

      unzipped_data = unzip_data(source, filename)

      routes = klass.normalize(unzipped_data)

      puts "Collected #{routes.length} routes"
      gate.send_back!(source, routes)
    end

    def unzip_data(source, filename)
      data = {}

      Zip::File.open(filename) do |zip_file|
        zip_file.each do |entry|
          next if entry.ftype != :file
          next if entry.name.include?('__MACOSX')

          short_name = entry.name.gsub("#{source}/", '')
          data[short_name] = entry.get_input_stream.read
        end
      end

      data
    end

    def save_archive(source, response)
      return unless response.respond_to?(:headers)
      return unless response.headers['content-type'].include?('application/zip')

      content = response.body
      return if content.empty?

      data_folder = File.join('.', 'data')
      filename = File.join(data_folder, source + '.zip')

      FileUtils.mkdir_p(data_folder)
      File.open(filename, 'w'){ |file| file.write(content) }
      filename
    end

  end
end