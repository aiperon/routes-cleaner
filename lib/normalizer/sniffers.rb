
module Normalizer
  class Sniffers

    class << self

      def normalize(data)

        node_times = parse_csv(data['node_times.csv'], 'node_time_id')
        routes = parse_csv(data['routes.csv'], 'route_id')
        sequences = parse_csv(data['sequences.csv'], 'route_id')

        route_chains = sequences.map do |route_id, sequence|
          route_row = routes[route_id].first
          next if !route_row

          sequence = sequence.map{ |row| node_times[row['node_time_id']].first }.compact
          next if sequence.empty?

          start_time = Time.parse(route_row['time'] + ' ' + route_row['time_zone'])
          total_duration = sequence.inject(0) do |memo, row|
            memo + row['duration_in_milliseconds'].to_i
          end
          end_time = start_time + total_duration / 1000.0

          {
            start_node: sequence.first['start_node'],
            end_node: sequence.last['end_node'],
            start_time: start_time,
            end_time: end_time
          }
        end.compact
      end

      def parse_csv(content, key)
        csv = CSV.new(content, col_sep: ', ', headers: true)
        data = Hash.new{|h, v| h[v] = []}
        while row = csv.shift
          data[row[key]] << row.to_hash
        end
        data
      end
    end
  end
end