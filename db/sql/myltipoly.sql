SELECT AddGeometryColumn('relations', 'geom', 4326, 'POLYGON', 2);

select * from relations
  join (
         select relation_id from relation_members as M
         group by relation_id
         having 'outer' = all( select member_role from relation_members where relation_members.relation_id = M.relation_id)
       ) as simple_multipoly
    on relations.id = simple_multipoly.relation_id
where tags->'type' = 'multipolygon'
  and tags->'boundary' = 'administrative';

CREATE OR REPLACE FUNCTION concatenate_ways(multipoly bigint)
  RETURNS geometry[]
AS $$
    if not SD.has_key("nodes_plan"):
        SD["nodes_plan"] = plpy.prepare("select nodes from ways where ways.id in ( select member_id from relation_members where relation_id = $1 and member_role = 'outer')", ["bigint"])
        SD["geoms_plan"] = plpy.prepare("select geom from nodes where id = $1", ["bigint"])
    nodes_plan = SD["nodes_plan"]
    geoms_plan = SD["geoms_plan"]

    res = plpy.execute(nodes_plan, [multipoly])
    sequences = [r["nodes"] for r in res]
    try:
        head, tail = sequences[0], sequences[1:]
        while len(tail) > 0 and head[0] != head[-1]: #TODO remove hack
            nxt = next(seq for seq in tail if (seq[0] == head[-1] or seq[-1] == head[0] or seq[-1] == head[-1]))
            tail.remove(nxt)
            if nxt[-1] == head[0]:
                head = nxt[:-1] + head
            else:
                if nxt[-1] == head[-1]:
                    nxt.reverse()
                head += nxt[1:]
        if not head[0] == head[-1]:
            head.append(head[0]) #TODO remove hack
        if len(head) > 3:
            return [plpy.execute(geoms_plan, [id])[0]["geom"] for id in head]
        else:
            return None
    except:
        return None
$$ LANGUAGE plpythonu;

UPDATE relations
SET geom = ST_MakePolygon(ST_MakeLine(concatenate_ways(id)))
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

CREATE OR REPLACE FUNCTION safe_st_contains(geom1 geometry, geom2 geometry)
  RETURNS BOOL AS
  $$
  BEGIN
    RETURN ST_Contains($1, $2);
    EXCEPTION WHEN others THEN
      RAISE NOTICE 'TopologyException';
      RETURN FALSE;
  END;
  $$
LANGUAGE plpgsql;
