SELECT AddGeometryColumn('relations', 'geom', 4326, 'POLYGON', 2);

UPDATE relations
SET geom = concatenate_ways(id)
WHERE id IN (
  SELECT id FROM relations
    JOIN (
           SELECT relation_id FROM relation_members AS M
           GROUP BY relation_id
           HAVING 'inner' != ALL (SELECT member_role FROM relation_members
           WHERE relation_members.relation_id = M.relation_id)
         ) AS simple_poly
      ON relations.id = simple_poly.relation_id
  WHERE tags -> 'boundary' = 'administrative'
     OR tags ? 'place'
);
