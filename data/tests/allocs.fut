-- Nasty program that tries to leak memory.  If we can run this
-- without leaking, then we're doing well.
-- ==
-- input { [0, 1000, 42, 1001, 50000] }
-- output { 1300103225i32 }

fun int main([int,n] a) =
  loop(b = iota(10)) = for i < n do
    (let m = a[i]
     in if m < size(0, b)
        then b
        else map(fn int (int j) =>
                   j + unsafe b[j % size(0,b)],
                 iota(m)))
  in reduce(+, 0, b)
