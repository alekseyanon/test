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


CREATE SEQUENCE agc_id_seq;
CREATE table agcs (id bigint NOT NULL DEFAULT nextval('agc_id_seq'), relations bigint[] NOT NULL);
ALTER sequence agc_id_seq owned BY agcs.id

-- creating every AGC of length 4 starting at uppermost level available
insert into agcs (relations)
select array[R1.id, R2.id, R3.id, R4.id] from relations as R1
join relations as R2
    on
           R1.geom is not null
       and R2.geom is not null
       and R1.id != R2.id
       and R1.tags -> 'boundary' = 'administrative'
       and R2.tags -> 'boundary' = 'administrative'
       and Safe_ST_Contains(R1.geom, R2.geom)
join relations as R3
    on R3.geom is not null
       and R2.id != R3.id
       and R3.tags -> 'boundary' = 'administrative'
       and Safe_ST_Contains(R2.geom, R3.geom)
join relations as R4
    on R4.geom is not null
       and R3.id != R4.id
       and R4.tags -> 'boundary' = 'administrative'
       and Safe_ST_Contains(R3.geom, R4.geom)
where not exists (
    select id from relations as R
    where R.geom is not null
      and R.tags -> 'boundary' = 'administrative'
      and R.id != R1.id
      and Safe_ST_Contains(R.geom, R1.geom))

-- first pass, create every AGC of length 2 starting at uppermost level available
insert into agc(relations)
select array[R1.id, R2.id] from relations as R1
  join relations as R2
    on
          R1.geom is not null
      and R2.geom is not null
      and R1.id != R2.id
      and R1.tags -> 'boundary' = 'administrative'
      and R2.tags -> 'boundary' = 'administrative'
      and Safe_ST_Contains(R1.geom, R2.geom)
where not exists (
    select id from relations as R
    where R.geom is not null
          and R.tags -> 'boundary' = 'administrative'
          and R.id != R1.id
          and Safe_ST_Contains(R.geom, R1.geom))
and not exists (                            --TODO optimize using results count = 1
    select id from relations as R
    where R.geom is not null
      and R.tags -> 'boundary' = 'administrative'
      and R.id != R2.id
      and R.id != R1.id
      and Safe_ST_Contains(R.geom, R2.geom));

-- second pass, create every AGC of length 3, based on those of length 2
insert into agc(relations)
  select array[A0.relations[1], R1.id, R2.id] from relations as R1
    join relations as R2
      on
        R1.id = any(select relations[2] from agc where array_length(relations,1) = 2)
        and R1.id != R2.id
        and R2.geom is not null
        and R2.tags -> 'boundary' = 'administrative'
        and Safe_ST_Contains(R1.geom, R2.geom)
    join (select relations from agc where array_length(agc.relations,1) = 2) A0
      on R1.id = A0.relations[2]
  where not exists (                            --TODO optimize using results count = 1
      select id from relations as R
      where R.geom is not null
        and R.tags -> 'boundary' = 'administrative'
        and R.id != R2.id
        and R.id != R1.id
        and R.id != A0.relations[1]
        and Safe_ST_Contains(R.geom, R2.geom));