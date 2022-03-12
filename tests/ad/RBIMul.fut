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
-- input { 
--            [1i64, 3i64, 2i64,-1i64, 2i64, 1i64, 1i64, 2i64, 3i64, 2i64, 4i64, 2i64, 2i64]
--            [1f32, 5f32, 1f32, 6f32, 2f32, 4f32, 2f32, 1f32, 2f32, 1f32, 5f32, 1f32, 6f32]
--            [1f32, 1f32, 1f32, 1f32]
--				 }
-- output { 
--            [8f32, 2f32, 12f32, 0f32, 6f32, 2f32, 4f32, 12f32, 5f32, 12f32, 0f32, 12f32, 2f32]
--            [1f32, 8f32, 12f32, 10f32]
--        }
-- input { 
--            [1i64, 3i64, 2i64,-1i64, 2i64, 1i64, 1i64, 2i64, 3i64, 2i64, 4i64, 2i64, 2i64]    
--            [0f32, 0f32, 0f32, 6f32, 0f32, 0f32, 0f32, 0f32, 0f32, 0f32, 5f32, 0f32, 0f32]
--            [1f32, 1f32, 1f32, 1f32]
--				 }
-- output { 
--            [0f32, 0f32, 0f32, 0f32, 0f32, 0f32, 0f32, 0f32, 0f32, 0f32, 0f32, 0f32, 0f32]
--            [1f32, 0f32, 0f32, 0f32]
--        }



let histo_mul [w][n] (is: [n]i64) (vs: [n]f32, dest: [w]f32) : [w]f32 =
  reduce_by_index (copy dest) (*) 1.0f32 is vs

entry main [n][w](is: [n]i64) (vs: [n]f32) (hist_bar': [w]f32) =
  vjp (histo_mul is) (vs, replicate w 1.0f32) hist_bar'
  
