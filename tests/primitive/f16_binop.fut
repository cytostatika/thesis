entry add = map2 (f16.+)
entry sub = map2 (f16.-)
entry mul = map2 (f16.*)
entry div = map2 (f16./)
entry mod = map2 (f16.%)
entry pow = map2 (f16.**)

-- ==
-- entry: add
-- input  { [0.0f16, 1.0f16, 1.0f16, -1.0f16, 3.402823e38f16, 0f16,    0f16]
--          [0.0f16, 0.0f16, 0.0f16,  0.0f16, 10f16,          f16.nan, f16.inf] }
-- output { [0.0f16, 1.0f16, 1.0f16, -1.0f16, f16.inf,        f16.nan, f16.inf] }

-- ==
-- entry: sub
-- input  { [0.0f16, 0.0f16, 0.0f16, -3.402823e38f16]
--          [0.0f16, 1.0f16, -1.0f16, 10f16] }
-- output { [0.0f16, -1.0f16, 1.0f16, -f16.inf] }

-- ==
-- entry: mul
-- input  { [0.0f16, 0.0f16,  0.0f16,  1.0f16, 2.0f16]
--          [0.0f16, 1.0f16, -1.0f16, -1.0f16, 1.5f16] }
-- output { [0.0f16, 0.0f16, 0.0f16, -1.0f16, 3.0f16] }

-- ==
-- entry: div
-- input { [0.0f16, 0.0f16, 1.0f16, 2.0f16]
--         [1.0f16, -1.0f16, -1.0f16, 1.5f16] }
-- output { [0.0f16, 0.0f16, -1.0f16, 1.3333333333333f16] }

-- ==
-- entry: mod
-- input { [0.0f16,  0.0f16,  1.0f16, 2.0f16]
--         [1.0f16, -1.0f16, -1.0f16, 1.5f16] }

-- ==
-- entry: pow
-- input  { [0.0f16,  1.0f16, 2.0f16,                2.0f16]
--          [1.0f16, -1.0f16, 1.5f16,                0f16] }
-- output { [0.0f16,  1.0f16, 2.8284271247461903f16, 1f16] }
