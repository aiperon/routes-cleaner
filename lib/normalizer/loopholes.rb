class Normalizer::Loopholes

  def self.normalize(data)
    return [] unless data

    node_pairs = JSON.parse(data['node_pairs.json'])['node_pairs']
    routes     = JSON.parse(data['routes.json'])['routes']

    grouped = Hash.new{|h, v| h[v] = []}

    pairs = {}
    node_pairs.each{ |pair| pairs[pair['id']] = pair }

    routes.each{ |route| grouped[route['route_id']] << route }

    grouped.map do |route_id, rows|
      next if rows.length < 2

      rows.sort!{ |a, b| a['start_time'] <=> b['start_time'] }
      start = rows.first
      finish = rows.last

      {
        start_node: pairs.dig(start['node_pair_id'], 'start_node'),
        end_node:   pairs.dig(finish['node_pair_id'], 'end_node'),
        start_time: Time.parse(start['start_time']),
        end_time:   Time.parse(finish['end_time'])
      }

    end.compact
  end

end