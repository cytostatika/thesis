-- Test for the generalised RBI. Only computes relative to vs and filters out any results corresponding to OOB indeces (would be zero vectors)
-- ==
-- entry: fwd rev
-- compiled input { 
-- [0i64, 0i64, 1i64, 1i64, 2i64, 2i64, 3i64, 3i64, 4i64, 4i64, 5i64, 5i64]    
-- [2f32, 1f32, 1f32, 1f32, 1f32, 1f32, 1f32, 2f32, 2f32, 1f32, 5f32, 1f32]
-- [1f32, 1f32, 1f32, 1f32]
-- } output {[[1f32, 0f32, 0f32, 0f32], [2f32, 0f32, 0f32, 0f32], [0f32, 1f32, 0f32, 0f32], [0f32, 1f32, 0f32, 0f32], [0f32, 0f32, 1f32, 0f32], [0f32, 0f32, 1f32, 0f32], [0f32, 0f32, 0f32, 2f32], [0f32, 0f32, 0f32, 1f32]]}
-- compiled input { 
-- [0i64, 0i64, 1i64, 1i64, 2i64, 2i64, 3i64, 3i64, 4i64, 4i64, 5i64, 5i64]    
-- [1f32, 1f32, 1f32, 1f32, 1f32, 1f32, 1f32, 2f32, 0f32, 0f32, 0f32, 0f32]
-- [1f32, 1f32, 1f32, 1f32, 1f32]
-- } output {[[1f32, 0f32, 0f32, 0f32, 0f32], [1f32, 0f32, 0f32, 0f32, 0f32], [0f32, 1f32, 0f32, 0f32, 0f32], [0f32, 1f32, 0f32, 0f32, 0f32], [0f32, 0f32, 1f32, 0f32, 0f32], [0f32, 0f32, 1f32, 0f32, 0f32], [0f32, 0f32, 0f32, 2f32, 0f32], [0f32, 0f32, 0f32, 1f32, 0f32], [0f32, 0f32, 0f32, 0f32, 0f32], [0f32, 0f32, 0f32, 0f32, 0f32]]}
-- compiled input { 
-- [0i64, 0i64, 1i64, 1i64, 2i64, 2i64, 3i64, 3i64, 4i64, 4i64, 5i64, 5i64]    
-- [1f32, 1f32, 1f32, 1f32, 1f32, 1f32, 1f32, 2f32, 0f32, 0f32, 0f32, 0f32]
-- [1f32, 5f32, 1f32, 7f32, 3f32]   
-- } output {[[1f32, 0f32, 0f32, 0f32, 0f32], [1f32, 0f32, 0f32, 0f32, 0f32], [0f32, 5f32, 0f32, 0f32, 0f32], [0f32, 5f32, 0f32, 0f32, 0f32], [0f32, 0f32, 1f32, 0f32, 0f32], [0f32, 0f32, 1f32, 0f32, 0f32], [0f32, 0f32, 0f32, 14f32, 0f32], [0f32, 0f32, 0f32, 7f32, 0f32], [0f32, 0f32, 0f32, 0f32, 0f32], [0f32, 0f32, 0f32, 0f32, 0f32]]}
-- compiled input { 
-- [-1i64, -1i64, 1i64, 1i64, 2i64, 2i64, 3i64, 3i64]    
-- [2f32, 2f32, 1f32, 3f32, 4f32, 1f32, 2f32, 6f32]
-- [1f32, 0f32, 1f32, 1f32]
-- } output {[[0f32, 0f32, 0f32, 0f32], [0f32, 0f32, 0f32, 0f32], [0f32, 0f32, 1f32, 0f32], [0f32, 0f32, 4f32, 0f32], [0f32, 0f32, 0f32, 6f32], [0f32, 0f32, 0f32, 2f32]]}
-- compiled input { 
-- [-1i64, -1i64, 6i64, 5i64, 21i64, 21i64, 322i64, 312i64]    
-- [2f32, 2f32, 1f32, 3f32, 4f32, 1f32, 2f32, 6f32]
-- [12f32, 23f32, 44f32, 122f32]
-- } output {empty([0][4]f32)}

def onehot (n: i64) (i: i64) (inp: f32) : [n]f32 =
  tabulate n (\j -> if (i==j) then inp else 0.0f32)
  

-- Note: Multiplication
let histo_mul [n][w](is: [n]i64) (dest: [w]f32) (vs: [n]f32) : [w]f32 =
  reduce_by_index (copy dest) (*) 1f32 is vs

entry rev [n][w](is: [n]i64) (vs: [n]f32) (hist_bar': [w]f32) =
  map (\i -> vjp (histo_mul is (replicate w 1f32)) vs (onehot w i hist_bar'[i])) (iota w) |> transpose |> zip is |> filter (\(i,_) -> (i < w) && (i >= 0)) |> unzip2 |> (\(_,a) -> a)
  

entry fwd [n][w](is: [n]i64) (vs: [n]f32) (hist_bar': [w]f32) =
  map (jvp (histo_mul is (replicate w 1f32)) vs) 
    (map (\ i -> onehot n i hist_bar'[is[i]]) (filter (\i -> (is[i] < w) && (is[i] >= 0)) (iota n)))

   