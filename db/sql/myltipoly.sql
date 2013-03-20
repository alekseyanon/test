select * from relations
  join (
         select relation_id from relation_members as M
         group by relation_id
         having 'outer' = all( select member_role from relation_members where relation_members.relation_id = M.relation_id)
       ) as simple_multipoly
    on relations.id = simple_multipoly.relation_id
where tags->'type' = 'multipolygon'
  and tags->'boundary' = 'administrative'
