UPDATE geo_units AS G
SET agc_id = (
  SELECT A.id FROM agcs AS A
    JOIN nodes ON nodes.id = G.osm_id
    JOIN relations
      ON A.relations [array_length(A.relations, 1)] = relations.id --TODO a shorter way to get last element?
  WHERE ST_Contains(relations.geom, nodes.geom)
  ORDER BY array_length(A.relations, 1) DESC
  LIMIT 1);