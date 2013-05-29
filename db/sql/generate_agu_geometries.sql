INSERT INTO agus (title, geom, created_at, updated_at, place, osm_tags)
SELECT  tags -> 'name', concatenate_ways(id), current_date, current_date,
        tags ? 'place' AND (tags -> 'place' = 'city' OR
        tags -> 'place' = 'town' OR
        tags -> 'place' = 'village' OR
        tags -> 'place' = 'hamlet' OR
        tags -> 'place' = 'allotments'), slice(tags, ARRAY['place'])
FROM relations
  JOIN (
         SELECT relation_id FROM relation_members AS M
         GROUP BY relation_id
         HAVING 'inner' != ALL (SELECT member_role FROM relation_members
         WHERE relation_members.relation_id = M.relation_id)
       ) AS simple_poly
    ON relations.id = simple_poly.relation_id
WHERE (tags -> 'boundary' = 'administrative'
               OR tags ? 'place')
      AND (tags -> 'name') IS NOT NULL;
