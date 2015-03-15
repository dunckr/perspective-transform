module.exports =
  isPowerOfTwo: (x) ->
    (x & x - 1) == 0

  nextHighestPowerOfTwo: (x) ->
    --x
    i = 1
    while i < 32
      x = x | x >> i
      i <<= 1
    x + 1

