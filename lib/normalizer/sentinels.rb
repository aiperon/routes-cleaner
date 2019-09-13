require 'zip'

module Normalizer
  class Sentinels

    def self.normalize(data)
      return [] unless data

      csv = CSV.new(data['routes.csv'], col_sep: ', ', headers: true)
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
          start_time: Time.parse(start['time']),
          end_time: Time.parse(finish['time']),
        }
      end.compact
    end
  end
end
