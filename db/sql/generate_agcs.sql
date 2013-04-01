CREATE SEQUENCE agcs_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;

CREATE table agcs (id bigint NOT NULL, relations bigint[] NOT NULL);

ALTER sequence agcs_id_seq owned BY agcs.id;


-- first pass, create every AGC of length 2 starting at uppermost level available
insert into agcs(relations)
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
insert into agcs(relations)
  select array[A0.relations[1], R1.id, R2.id] from relations as R1
    join relations as R2
      on
        R1.id = any(select relations[2] from agcs where array_length(relations,1) = 2)
        and R1.id != R2.id
        and R2.geom is not null
        and R2.tags -> 'boundary' = 'administrative'
        and Safe_ST_Contains(R1.geom, R2.geom)
    join (select relations from agcs where array_length(agcs.relations,1) = 2) A0
      on R1.id = A0.relations[2]
  where not exists (                            --TODO optimize using results count = 1
      select id from relations as R
      where R.geom is not null
        and R.tags -> 'boundary' = 'administrative'
        and R.id != R2.id
        and R.id != R1.id
        and R.id != A0.relations[1]
        and Safe_ST_Contains(R.geom, R2.geom));
