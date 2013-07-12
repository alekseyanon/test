collection @agus

attributes :title

code(:map_bounds)  { |m| m.to_map_bounds }
code(:centre)      { |m| c = m.geom.centroid; [c.x, c.y] }
