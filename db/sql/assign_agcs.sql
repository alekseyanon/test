UPDATE geo_objects AS G
SET agc_id = (
  SELECT A.id FROM agcs AS A
    JOIN relations
      ON A.relations [array_length(A.relations, 1)] = relations.id --TODO a shorter way to get last element?
  WHERE ST_Contains(relations.geom, G.geom)
  ORDER BY array_length(A.relations, 1) DESC
  LIMIT 1);
