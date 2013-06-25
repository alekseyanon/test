class Clustering
  def self.from_chain(chain, clusters)
    res = ActiveRecord::Base.connection.execute "SELECT ST_AsText(ST_Centroid(ST_Collect(geom))) as geom, array_agg(id) AS member_ids
        FROM (SELECT id, geom, kmeans(ARRAY[ST_X(geom), ST_Y(geom)], #{clusters}) OVER () FROM (#{chain.to_sql}) AS chain
      ) AS ksub
      GROUP BY kmeans
      ORDER BY kmeans"
    res.map do |row|
      {geom: Geo::factory.parse_wkt(row['geom']),
       member_ids: row['member_ids'].from_postgres_array(:integer)}
    end
  end
end
