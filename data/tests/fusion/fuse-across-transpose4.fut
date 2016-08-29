-- ==
-- input { [[1,2,3],[4,5,6]] [[7,8,9],[1,2,3]] }
-- output { [[10, 7], [12, 9], [14, 11]] }
-- structure { Map 2 }
fun main(a: [n][m]int, b: [n][m]int): [][]int =
  let a2 = map (fn (r: []int): [n]int  => map (+1) r) (transpose(a)) in
  let b2 = map (fn (r: []int): [n]int  => map (+1) r) (transpose(b)) in
  let c  = map (fn (rp: ([]int,[]int)): [n]int  =>
                 let (rx,ry) = rp in
                 map (+) (zip rx ry)) (
               zip a2 b2) in
  c
