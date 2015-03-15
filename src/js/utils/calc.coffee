numeric = require "../vendor/numeric"

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

  transformationFromQuadCorners: (before, after) ->
    ###
     Return the 8 elements of the transformation matrix which maps
     the points in *before* to corresponding ones in *after*. The
     points should be specified as
     [{x:x1,y:y1}, {x:x2,y:y2}, {x:x3,y:y2}, {x:x4,y:y4}].

     Note: There are 8 elements because the bottom-right element is
     assumed to be '1'.
    ###

    b = numeric.transpose([ [
      after[0].x
      after[0].y
      after[1].x
      after[1].y
      after[2].x
      after[2].y
      after[3].x
      after[3].y
    ] ])
    A = []
    i = 0
    while i < before.length
      A.push [
        before[i].x
        0
        -after[i].x * before[i].x
        before[i].y
        0
        -after[i].x * before[i].y
        1
        0
      ]
      A.push [
        0
        before[i].x
        -after[i].y * before[i].x
        0
        before[i].y
        -after[i].y * before[i].y
        0
        1
      ]
      i++
    # Solve for T and return the elements as a single array
    numeric.transpose(numeric.dot(numeric.inv(A), b))[0]


