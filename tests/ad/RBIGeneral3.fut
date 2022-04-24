-- Simple histogram with multiplication
-- ==
-- entry: fwd rev


let histo_mul [n][w](is: [n]i64) (dest: [w]f32) (vs: [n]f32) : [w]f32 =
  reduce_by_index (copy dest) (*) 1f32 is vs

entry rev [n][w](is: [n]i64) (vs: [n]f32) (hist_bar': [w]f32) =
  vjp (histo_mul is (replicate w 1f32)) vs hist_bar'
  

entry fwd [n][w](is: [n]i64) (vs: [n]f32) (hist_bar': [w]f32) =
  map (jvp (histo_mul is (replicate w 1f32)) vs) 
    (map (\js -> map2 (\ i j -> if i == j then 1f32 else 0f32) (iota n) (replicate n js)) (iota n))

  -- [[1i64, 0i64, 0i64, 0i64],
  --  [0i64, 1i64, 0i64, 0i64],
  --  [0i64, 0i64, 1i64, 0i64],
  --  [0i64, 0i64, 0i64, 1i64]]
  
    -- [([1i64, 0i64, 0i64, 0i64], replicate 4 1i64),
    --   ([0i64, 1i64, 0i64, 0i64], replicate 4 1i64),
    --   ([0i64, 0i64, 1i64, 0i64], replicate 4 1i64),
    --   ([0i64, 0i64, 0i64, 1i64], replicate 4 1i64)]
   