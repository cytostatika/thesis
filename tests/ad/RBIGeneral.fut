-- Simple histogram with multiplication
-- ==

let histo_or [n][w](is: [n]i64) (dest: [w]f32) (vs: [n]f32) : [w]f32 =
  reduce_by_index (copy dest) (*) 1f32 is vs

entry main [n][w](is: [n]i64) (vs: [n]f32) (hist_bar': [w]f32) =
  vjp (histo_or is (replicate w 1f32)) vs hist_bar'
   