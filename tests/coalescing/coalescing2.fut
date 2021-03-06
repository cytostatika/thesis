-- ==
-- input { [[[7i32, 10i32, 2i32],
--           [4i32, 3i32, 1i32],
--           [8i32, 4i32, 4i32],
--           [0i32, 9i32, 9i32],
--           [0i32, 1i32, 3i32],
--           [2i32, 5i32, 10i32],
--           [0i32, 5i32, 0i32]],
--          [[5i32, 7i32, 6i32],
--           [2i32, 2i32, 3i32],
--           [4i32, 4i32, 7i32],
--           [6i32, 10i32, 10i32],
--           [5i32, 6i32, 10i32],
--           [5i32, 1i32, 6i32],
--           [1i32, 3i32, 9i32]],
--          [[3i32, 2i32, 9i32],
--           [4i32, 0i32, 7i32],
--           [4i32, 6i32, 5i32],
--           [5i32, 8i32, 5i32],
--           [10i32, 8i32, 7i32],
--           [5i32, 8i32, 7i32],
--           [3i32, 6i32, 8i32]]] }
-- output { [[50i32, 23i32, 44i32, 27i32, 5i32, 28i32, 10i32],
--           [40i32, 15i32, 31i32, 54i32, 42i32, 28i32, 19i32],
--           [25i32, 23i32, 33i32, 41i32, 63i32, 43i32, 32i32]] }

def main [k][n][m] (rss: [k][n][m]i32): [][]i32 =
  map (\(rs: [][]i32)  ->
        map (\(r: []i32): i32  ->
              loop x = 0 for i < m do
                x * 2 + r[i]) rs) rss
