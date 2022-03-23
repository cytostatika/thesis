-- Simple histogram with addition
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

let histo_fused [w][n] (is: [n]i64) (vs: [n]f32, dest: [w]f32) : [w]f32 =
  reduce_by_index (copy dest) (+) 0.0f32  (map2 (+) (map (i64.f32) vs) is) vs

entry main [n][w](is: [n]i64) (vs: [n]f32) (hist_bar': [w]f32) =
  vjp (histo_fused is) (vs, replicate w 0f32) hist_bar'
  
