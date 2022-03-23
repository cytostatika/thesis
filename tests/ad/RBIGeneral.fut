-- Simple histogram with multiplication
-- ==
-- input { 
--          [1i64, 3i64, 2i64,-1i64, 2i64, 1i64, 1i64, 2i64, 3i64, 2i64, 4i64, 2i64, 2i64]    
--          [1f32, 5f32, 1f32, 0f32, 2f32, 4f32, 2f32, 1f32, 2f32, 1f32, 5f32, 1f32, 0f32]
--          [1f32, 1f32, 1f32, 1f32]
--				 }
-- output { 
--            [8f32, 2f32, 0f32, 0f32, 0f32, 2f32, 4f32, 0f32, 5f32, 0f32, 0f32, 0f32, 2f32]
--            [1f32, 8f32, 0f32, 10f32]
--        }


--hardcoding it to i64 for now
let histo_minus [w][n] (is: [n]i64) (vs: [n]i64, dest: [w]i64) : [w]i64 =
  reduce_by_index (copy dest) (-) 0i64 is vs

entry main [n][w](is: [n]i64) (vs: [n]i64) (hist_bar': [w]i64) =
  vjp (histo_minus is) (vs, replicate w 0i64) hist_bar'
  

-- let histo_mul [w][n] (is: [n]i64) (vs: [n]f32, dest: [w]f32) : [w]f32 =
--   reduce_by_index (copy dest) (-) 0.0f32 is vs

-- entry main [n][w](is: [n]i64) (vs: [n]f32) (hist_bar': [w]f32) =
--   vjp (histo_mul is) (vs, replicate w 0.0f32) hist_bar'
  
