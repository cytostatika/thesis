-- Simple histogram with multiplication
-- ==
-- input { [1i64, 3i64, 2i64,-1i64, 2i64, 1i64, 1i64, 2i64, 3i64, 2i64,-1i64, 2i64, 2i64]
--				 [1f32, 1f32, 1f32, 1f32, 1f32, 1f32, 1f32, 1f32, 1f32, 1f32, 1f32, 1f32, 1f32]
--				 [1f32, 1f32, 1f32, 1f32]
--				  }
-- output { [8f32, 5f32, 7f32, 0f32, 7f32, 8f32, 8f32, 7f32, 5f32, 7f32, 0f32, 7f32, 7f32]
--					[9f32, 8f32, 7f32, 5f32]
--        }


let histo_mul [w][n] (is: [n]i64) (vs: [n]f32, dest: [w]f32) : [w]f32 =
  reduce_by_index (copy dest) (*) 1.0f32 is vs

entry main [n][w](is: [n]i64) (vs: [n]f32) (hist_bar': [w]f32) =
  vjp (histo_mul is) (vs, replicate w 1.0f32) hist_bar'
  
let is = [1i64, 3i64, 2i64,-1i64, 2i64, 1i64, 1i64, 2i64, 3i64, 2i64,-1i64, 2i64, 2i64]    
let vs = [1f32, 5f32, 1f32, 1f32, 2f32, 0f32, 2f32, 1f32, 0f32, 1f32, 1f32, 1f32, 0f32]
let hist_bar' = [1f32, 1f32, 1f32, 1f32]
