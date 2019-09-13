require 'zip'

module Normalizer
  class Sentinels

    def self.unzip_data(content)
      data = nil
      Zip::File.open_buffer(content) do |zip_file|
        zip_file.each do |entry|
          next unless entry.name == 'sentinels/routes.csv'
          data = zip_file.read(entry)
        end
      end
      data
    end

    def self.parse(response)
      return [] unless response.respond_to?(:headers) && response.headers['content-type'].include?('application/zip')

      data = unzip_data(response.body)

      return [] unless data

      csv = CSV.new(data, col_sep: ', ', headers: true)
      routes = Hash.new{|h, v| h[v] = []}
      while row = csv.shift
        routes[row['route_id']] << row.to_hash
      end

      route_chains = routes.map do |route_id, rows|
        next if rows.length < 2
        rows.sort!{|a,b| a['index'] <=> b['index']}
        start = rows.first
        finish = rows.last

        {
          start_node: start['node'],
          end_node: finish['node'],
          start_time: Time.parse(start['time']).utc.iso8601.gsub(/Z\z/, ''),
          end_time: Time.parse(finish['time']).utc.iso8601.gsub(/Z\z/, ''),
        }
      end.compact
    end
  end
end
