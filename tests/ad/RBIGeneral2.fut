-- Simple histogram with multiplication
-- ==
-- entry: fwd rev


let histo_mul [n][w](is: [n]i64) (dest: [w]i64) (vs: [n]i64) : [w]i64 =
  reduce_by_index (copy dest) (*) 1i64 is vs

entry rev [n][w](is: [n]i64) (vs: [n]i64) (hist_bar': [w]i64) =
  vjp (histo_mul is (replicate w 1i64)) vs hist_bar'
  

entry fwd [n][w](is: [n]i64) (vs: [n]i64) (hist_bar': [w]i64) =
  map (jvp (histo_mul is (replicate w 1i64)) vs) 
    (map (\js -> map2 (\ i j -> if i == j then 1 else 0) (iota n) (replicate n js)) (iota n))

  -- [[1i64, 0i64, 0i64, 0i64],
  --  [0i64, 1i64, 0i64, 0i64],
  --  [0i64, 0i64, 1i64, 0i64],
  --  [0i64, 0i64, 0i64, 1i64]]
  
    -- [([1i64, 0i64, 0i64, 0i64], replicate 4 1i64),
    --   ([0i64, 1i64, 0i64, 0i64], replicate 4 1i64),
    --   ([0i64, 0i64, 1i64, 0i64], replicate 4 1i64),
    --   ([0i64, 0i64, 0i64, 1i64], replicate 4 1i64)]
   