-- Simple histogram with multiplication
-- ==
-- entry: fwd rev


let histo_mul (is: [4]i64) (dest: [4]i64) (vs: [4]i64) : [4]i64 =
  reduce_by_index (copy dest) (*) 1i64 is vs

-- entry rev (is: [4]i64) (vs: [4]i64) (hist_bar': [4]i64) =
--   vjp (histo_mul is (replicate 4 1i64)) vs hist_bar'
  

entry fwd (is: [4]i64) (vs: [4]i64) (hist_bar': [4]i64) =
  map (jvp (histo_mul is (replicate 4 1i64)) vs) 
  [[1i64, 0i64, 0i64, 0i64],
   [0i64, 1i64, 0i64, 0i64],
   [0i64, 0i64, 1i64, 0i64],
   [0i64, 0i64, 0i64, 1i64]]
  
    -- [([1i64, 0i64, 0i64, 0i64], replicate 4 1i64),
    --   ([0i64, 1i64, 0i64, 0i64], replicate 4 1i64),
    --   ([0i64, 0i64, 1i64, 0i64], replicate 4 1i64),
    --   ([0i64, 0i64, 0i64, 1i64], replicate 4 1i64)]
   