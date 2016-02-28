-- This test has been distilled from CalibVolDiff and exposed a bug in
-- the memory expander.
--
-- ==
-- input {
--   [[1.0, 1.5, 2.5], [3.0, 6.5, 0.5]]
--   [[0.10, 0.15, 0.25], [0.30, 0.65, 0.05]]
--   [[0.1, 1.75], [1.0, 17.5]]
--   [[0.01, 1.705], [0.1, 17.05]]
--   [[0.02, 0.05], [0.04, 0.07]]
--   0.1
--   30
-- }
-- output { [[[-1.350561, 0.615297], [-0.225855, 0.103073]],
--           [[-1.776825, 0.812598], [-0.230401, 0.105177]],
--           [[-2.596339, 1.191926], [-0.235133, 0.107367]],
--           [[-4.819269, 2.220859], [-0.240064, 0.109650]],
--           [[-33.523365, 15.507273], [-0.245206, 0.112030]],
--           [[6.763457, -3.140509], [-0.250574, 0.114514]],
--           [[3.071727, -1.431704], [-0.256181, 0.117110]],
--           [[1.987047, -0.929638], [-0.262046, 0.119824]],
--           [[1.468468, -0.689606], [-0.268185, 0.122666]],
--           [[1.164528, -0.548925], [-0.274619, 0.125644]],
--           [[0.964817, -0.456489], [-0.281369, 0.128768]],
--           [[0.823568, -0.391114], [-0.288459, 0.132050]],
--           [[0.718389, -0.342435], [-0.295916, 0.135502]],
--           [[0.637028, -0.304780], [-0.303769, 0.139136]],
--           [[0.572216, -0.274786], [-0.312050, 0.142969]],
--           [[0.519370, -0.250331], [-0.320795, 0.147017]],
--           [[0.475458, -0.230010], [-0.330045, 0.151299]],
--           [[0.438389, -0.212858], [-0.339844, 0.155834]],
--           [[0.406681, -0.198186], [-0.350242, 0.160647]],
--           [[0.379247, -0.185493], [-0.361297, 0.165764]],
--           [[0.355280, -0.174405], [-0.373073, 0.171215]],
--           [[0.334161, -0.164635], [-0.385643, 0.177033]],
--           [[0.315410, -0.155961], [-0.399088, 0.183257]],
--           [[0.298649, -0.148209], [-0.413506, 0.189930]],
--           [[0.283580, -0.141239], [-0.429004, 0.197103]],
--           [[0.269957, -0.134939], [-0.445709, 0.204836]],
--           [[0.257582, -0.129217], [-0.463768, 0.213195]],
--           [[0.246292, -0.123996], [-0.483353, 0.222260]],
--           [[0.235948, -0.119214], [-0.504664, 0.232124]],
--           [[0.226438, -0.114818], [-0.527942, 0.242899]]]
-- }

fun *[f64] tridagSeq( [f64] a, *[f64] b, [f64] c, *[f64] y ) =
    let n     = size(0, a)            in
    loop ({y, b}) =
      for i < n-1 do
        let i    = i + 1              in
        let beta = a[i] / b[i-1]      in
        let b[i] = b[i] - beta*c[i-1] in
        let y[i] = y[i] - beta*y[i-1]
        in  {y, b}
    in
    let y[n-1] = y[n-1]/b[n-1] in
    loop (y) = for j < n - 1 do
                 let i    = n - 2 - j in
                 let y[i] = (y[i] - c[i]*y[i+1]) / b[i]
                 in  y
    in  y

fun *[[f64,m],n] implicitMethod( [[f64,3],m] myD,  [[f64,3],m] myDD,
                                  [[f64,m],n] myMu, [[f64,m],n] myVar,
                                  [[f64,m],n] u,    f64     dtInv  ) =
  map( fn *[f64] ( {[f64],[f64],*[f64]} tup )  =>
         let {mu_row,var_row,u_row} = tup in
         let abc = map( fn {f64,f64,f64} ({f64,f64,[f64],[f64]} tup) =>
                          let {mu, var, d, dd} = tup in
                          { 0.0   - 0.5*(mu*d[0] + 0.5*var*dd[0])
                          , dtInv - 0.5*(mu*d[1] + 0.5*var*dd[1])
                          , 0.0   - 0.5*(mu*d[2] + 0.5*var*dd[2])
                          }
                      , zip(mu_row, var_row, myD, myDD)
                      ) in
         let {a,b,c} = unzip(abc) in
         tridagSeq( a, b, c, u_row )
     , zip(myMu,myVar,copy(u))
     )

fun *[[[f64,m],n],num_samples]
  main( [[f64,3],m] myD,  [[f64,3],m] myDD,
        [[f64,m],n] myMu, [[f64,m],n] myVar,
        *[[f64,m],n] u,    f64     dtInv,
        int num_samples) =
  map(implicitMethod(myD, myDD, myMu, myVar, u),
      map (*dtInv, map (/f64(num_samples), map(f64, map(+1, iota(num_samples))))))
