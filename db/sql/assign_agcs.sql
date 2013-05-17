UPDATE geo_objects AS G
SET agc_id = (
  SELECT A.id FROM agcs AS A
    JOIN agus
      ON A.agus [array_length(A.agus, 1)] = agus.id --TODO a shorter way to get last element?
  WHERE ST_Contains(agus.geom, G.geom)
  ORDER BY array_length(A.agus, 1) DESC
  LIMIT 1);
