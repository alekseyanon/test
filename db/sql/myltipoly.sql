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
        SD["nodes_plan"] = plpy.prepare("select nodes from ways where ways.id in ( select member_id from relation_members where relation_id = $1)", ["bigint"])
        SD["geoms_plan"] = plpy.prepare("select geom from nodes where id = $1", ["bigint"])
    nodes_plan = SD["nodes_plan"]
    geoms_plan = SD["geoms_plan"]

    res = plpy.execute(nodes_plan, [multipoly])
    sequences = [r["nodes"] for r in res]
    head, tail = sequences[0], sequences[1:]
    while len(tail) > 0:
        nxt = next(seq for seq in tail if (seq[0] == head[-1] or seq[-1] == head[-1]))
        tail.remove(nxt)
        if nxt[-1] == head[-1]:
            nxt.reverse()
        head += nxt[1:]
    return [plpy.execute(geoms_plan, [id])[0]["geom"] for id in head]
$$ LANGUAGE plpythonu;