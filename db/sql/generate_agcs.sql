-- first pass, create every AGC of length 2 starting at uppermost level available
insert into agcs(agus)
select array[R1.id, R2.id] from agus as R1
  join agus as R2
    on R1.id != R2.id
   and Safe_ST_Contains(R1.geom, R2.geom)
where not exists (
    select id from agus as R
    where R.id != R1.id
      and Safe_ST_Contains(R.geom, R1.geom))
and not exists (                            --TODO optimize using results count = 1
    select id from agus as R
    where R.id != R2.id
      and R.id != R1.id
      and Safe_ST_Contains(R.geom, R2.geom));

-- second pass, create every AGC of length 3, based on those of length 2
insert into agcs(agus)
  select array[A0.agus[1], R1.id, R2.id] from agus as R1
    join agus as R2
      on R1.id = any(select agus[2] from agcs where array_length(agus,1) = 2)
     and R1.id != R2.id
     and Safe_ST_Contains(R1.geom, R2.geom)
    join (select agus from agcs where array_length(agcs.agus,1) = 2) A0
      on R1.id = A0.agus[2]
  where not exists (                            --TODO optimize using results count = 1
      select id from agus as R
      where R.id != R2.id
        and R.id != R1.id
        and R.id != A0.agus[1]
        and Safe_ST_Contains(R.geom, R2.geom));
