create language plpythonu;

-- Concatenating ways definitions belonging to a relation into a single polygon geometry
-- Input: relation id
-- Output: resulting polygon
CREATE OR REPLACE FUNCTION concatenate_ways(multipoly bigint)
  RETURNS geometry
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
            return ST_MakePolygon(ST_MakeLine( [plpy.execute(geoms_plan, [id])[0]["geom"] for id in head] ))
        else:
            return None
    except:
        return None
$$ LANGUAGE plpythonu;

-- Wrapper catching whatever exceptions are thrown by ST_Contains
-- TODO: fix catching every exception when PostGIS error codes are available
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
