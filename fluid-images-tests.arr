use context essentials2020
include shared-gdrive("fluid-images-definitions.arr", "1D3kQXSwA3yVSvobr_lv7WQIwUZhGCWBp")

include my-gdrive("fluid-images-common.arr")
import liquify-memoization, liquify-dynamic-programming
from my-gdrive("fluid-images-code.arr")
# END HEADER
# DO NOT CHANGE ANYTHING ABOVE THIS LINE
#
# Write your examples and tests in here. These should not be tests of
# implementation-specific details (e.g., helper functions).

#--------------------------------------------------------------------------------------------------
# Liquidfy memoization tests:

check "liquify memoization tests where seams to carve is 0":
  liquify-memoization(
    [image(3,3):
      color(1,1,1), color(2,2,2), color(3,3,3),
      color(4,4,4), color(5,5,5), color(6,6,6),
      color(7,7,7), color(8,8,8), color(9,9,9)], 0)
    is 
  [image(3,3):
      color(1,1,1), color(2,2,2), color(3,3,3),
      color(4,4,4), color(5,5,5), color(6,6,6),
      color(7,7,7), color(8,8,8), color(9,9,9)]
  liquify-memoization(
    [image(1, 4):
      color(1,1,1), 
      color(2,2,2), 
      color(3,3,3), 
      color(5,5,5)], 0)
    is 
  [image(1, 4):
    color(1,1,1), 
    color(2,2,2), 
    color(3,3,3), 
    color(5,5,5)]
end

check ```liquify memoization tests where if the seams overlap,
      the leftmost seam will be the one with the leftmost pixel in the topmost row 
      where the seams diverge```:
  liquify-memoization(
    [image(4,4):
      color(2,2,2), color(1,1,1), color(1,1,1), color(2,2,2),
      color(2,2,2), color(1,1,1), color(1,1,1), color(2,2,2),
      color(2,2,2), color(1,1,1), color(1,1,1), color(2,2,2),
      color(2,2,2), color(1,1,1), color(1,1,1), color(2,2,2)], 1)
    is 
  [image(3,4):
    color(1,1,1), color(1,1,1), color(2,2,2), 
    color(1,1,1), color(1,1,1), color(2,2,2), 
    color(1,1,1), color(1,1,1), color(2,2,2), 
    color(1,1,1), color(1,1,1), color(2,2,2)]
end

check ```liquify memoization tests removing just 1 one seam```:
  liquify-memoization(
    [image(4, 4):
      color(1,1,1), color(2,2,2), color(2,2,2), color(1,1,1),
      color(3,3,3), color(3,3,3), color(4,4,4), color(5,5,5),
      color(3,3,3), color(4,4,4), color(5,5,5), color(6,6,6),
      color(7,7,7), color(8,8,8), color(9,9,9), color(10,10,10)], 1)
  is 
  [image(3, 4):
    color(2,2,2), color(2,2,2), color(1,1,1),
    color(3,3,3), color(4,4,4), color(5,5,5),
    color(3,3,3), color(5,5,5), color(6,6,6),
    color(7,7,7), color(9,9,9), color(10,10,10)]
end

check ```liquify-memoization can handle an img that is only one row tall```:
  liquify-memoization([image(4, 1): 
      color(1,1,1), color(2,2,2), color(2,2,2), color(1,1,1)], 1)
    is 
  [image(3, 1): 
    color(1,1,1), color(2,2,2), color(1,1,1)]
  liquify-memoization(
    [image(4, 1): 
      color(1,1,1), color(2,2,2), color(2,2,2), color(1,1,1)], 2)
    is 
  [image(2, 1): 
    color(1,1,1), color(1,1,1)]
  liquify-memoization(
    [image(4, 1): 
      color(1,1,1), color(2,2,2), color(3,3,3), color(4,4,4)], 3)
    is 
  [image(1, 1):
    color(2, 2, 2)]
end

check ```liquify-memoization can handle an img that has only two columns 
      and we remove one of them```:
  liquify-memoization(
    [image(2, 5):
      color(1,1,1), color(1,1,1),
      color(2,2,2), color(2,2,2), 
      color(3,3,3), color(3,3,3),
      color(2,2,2), color(2,2,2), 
      color(1,1,1), color(1,1,1)], 1)
    is 
  [image(1, 5):
      color(1,1,1),
      color(2,2,2), 
      color(3,3,3),
      color(2,2,2), 
      color(1,1,1)]
  liquify-memoization(
  [image(2, 5):
      color(1,1,1), color(2,2,2),
      color(2,2,2), color(2,2,2), 
      color(3,3,3), color(3,3,3),
      color(5,5,5), color(2,2,2), 
      color(1,1,1), color(1,1,1)], 1)
    is 
  [image(1, 5):
    color(1,1,1), 
    color(2,2,2), 
    color(3,3,3),
    color(2,2,2), 
    color(1,1,1)]
  long-skinny = 
    [image(2,10):
      color(0,2,50), color(0,2,50),
      color(0,2,50), color(0,2,50),
      color(1,30,50), color(1,30,50),
      color(1,30,50), color(1,30,50),
      color(10,30,50), color(10,30,50),
      color(10,30,50), color(10,30,50),
      color(40,30,70), color(40,30,70),
      color(40,30,70), color(40,30,70),
      color(60,30,70), color(60,30,70),
      color(60,30,70), color(60,30,70)]
  liquify-memoization(long-skinny, 1) is 
  [image(1,10):
    color(0,2,50),
    color(0,2,50),
    color(1,30,50),
    color(1,30,50),
    color(10,30,50),
    color(10,30,50),
    color(40,30,70),
    color(40,30,70),
    color(60,30,70),
    color(60,30,70)]
end

check ```memoization when removing more than 1 seam```:
  liquify-memoization(
    [image(4, 4):
      color(1,1,1), color(2,2,2), color(2,2,2), color(1,1,1),
      color(3,3,3), color(3,3,3), color(4,4,4), color(5,5,5),
      color(3,3,3), color(4,4,4), color(5,5,5), color(6,6,6),
      color(7,7,7), color(8,8,8), color(9,9,9), color(10,10,10)], 2)
    is 
  [image(2, 4):
    color(2,2,2), color(1,1,1),
    color(3,3,3), color(5,5,5),
    color(3,3,3), color(6,6,6),
    color(7,7,7), color(10,10,10)]
  liquify-memoization(
    [image(5, 4):
      color(1,1,1), color(2,2,2), color(2,2,2), color(1,1,1), color(3,3,3),
      color(3,3,3), color(3,3,3), color(4,4,4), color(5,5,5), color(4,4,4),
      color(3,3,3), color(4,4,4), color(5,5,5), color(6,6,6), color(5,5,5),
      color(7,7,7), color(8,8,8), color(9,9,9), color(10,10,10), color(6,6,6)], 3)
    is 
  [image(2, 4):
    color(1, 1, 1), color(3, 3, 3),
    color(3, 3, 3), color(4, 4, 4), 
    color(3, 3, 3), color(5, 5, 5), 
    color(7, 7, 7), color(6, 6, 6)]
end

check ```memoization tests where the two middle seams contenderes tie in nrg, 
      and we are forced to pick the leftmost one```:
  liquify-memoization(
    [image(4, 5):
      color(1,1,1), color(1,1,1), color(1,1,1), color(1,1,1),
      color(1,1,1), color(5,5,5), color(5,5,5), color(1,1,1),
      color(1,1,1), color(1,1,1), color(1,1,1), color(1,1,1),
      color(1,1,1), color(5,5,5), color(5,5,5), color(1,1,1),
      color(1,1,1), color(1,1,1), color(1,1,1), color(1,1,1)], 1)
    is 
  [image(3, 5):
    color(1,1,1), color(1,1,1), color(1,1,1),
    color(1,1,1), color(5,5,5), color(1,1,1),
    color(1,1,1), color(1,1,1), color(1,1,1),
    color(1,1,1), color(5,5,5), color(1,1,1),
    color(1,1,1), color(1,1,1), color(1,1,1)]
end

#-----------------------------------------------------------------------------------
# Dynamic Programming tests

check ```dynamic tests where the two middle seams contenderes tie in nrg, 
      and we are forced to pick the leftmost one```:
  liquify-dynamic-programming(
    [image(4, 5):
      color(1,1,1), color(1,1,1), color(1,1,1), color(1,1,1),
      color(1,1,1), color(5,5,5), color(5,5,5), color(1,1,1),
      color(1,1,1), color(1,1,1), color(1,1,1), color(1,1,1),
      color(1,1,1), color(5,5,5), color(5,5,5), color(1,1,1),
      color(1,1,1), color(1,1,1), color(1,1,1), color(1,1,1)], 1)
    is 
  [image(3, 5):
    color(1,1,1), color(1,1,1), color(1,1,1),
    color(1,1,1), color(5,5,5), color(1,1,1),
    color(1,1,1), color(1,1,1), color(1,1,1),
    color(1,1,1), color(5,5,5), color(1,1,1),
    color(1,1,1), color(1,1,1), color(1,1,1)]
end

check ```dynamic programming tests where the image is only one row tall```:
  liquify-dynamic-programming(
    [image(4, 1): 
      color(1,1,1), color(2,2,2), color(3,3,3), color(4,4,4)], 3)
    is 
  [image(1, 1):
    color(2, 2, 2)]
end

check "dynamic programming tests where the input image is only two columns wide, and we remove 1":
  long-skinny = 
    [image(2, 10):
      color(0,2,50), color(0,2,50),
      color(0,2,50), color(0,2,50),
      color(1,30,50), color(1,30,50),
      color(1,30,50), color(1,30,50),
      color(10,30,50), color(10,30,50),
      color(10,30,50), color(10,30,50),
      color(40,30,70), color(40,30,70),
      color(40,30,70), color(40,30,70),
      color(60,30,70), color(60,30,70),
      color(60,30,70), color(60,30,70)]
  liquify-dynamic-programming(long-skinny, 1) is 
  [image(1, 10):
    color(0,2,50),
    color(0,2,50),
    color(1,30,50),
    color(1,30,50),
    color(10,30,50),
    color(10,30,50),
    color(40,30,70),
    color(40,30,70),
    color(60,30,70),
    color(60,30,70)]
end

check ```dynamic-programming tests where seams to carve is 0```:
  liquify-dynamic-programming(
    [image(3, 3):
      color(1,1,1), color(2,2,2), color(3,3,3),
      color(4,4,4), color(5,5,5), color(6,6,6),
      color(7,7,7), color(8,8,8), color(9,9,9)], 0)
    is 
  [image(3, 3):
      color(1,1,1), color(2,2,2), color(3,3,3),
      color(4,4,4), color(5,5,5), color(6,6,6),
      color(7,7,7), color(8,8,8), color(9,9,9)]
   liquify-dynamic-programming(
    [image(1, 4):
      color(1,1,1), 
      color(2,2,2), 
      color(3,3,3), 
      color(5,5,5)], 0)
    is 
  [image(1, 4):
    color(1,1,1), 
    color(2,2,2), 
    color(3,3,3), 
    color(5,5,5)]
end

check ```dynamic-programming tests where if the seams overlap,
      the leftmost seam will be the one with the leftmost pixel in the topmost row 
      where the seams diverge```:
  liquify-dynamic-programming(
    [image(4, 4):
      color(2,2,2), color(1,1,1), color(1,1,1), color(2,2,2),
      color(2,2,2), color(1,1,1), color(1,1,1), color(2,2,2),
      color(2,2,2), color(1,1,1), color(1,1,1), color(2,2,2),
      color(2,2,2), color(1,1,1), color(1,1,1), color(2,2,2)], 1)
    is 
  [image(3, 4):
    color(1,1,1), color(1,1,1), color(2,2,2), 
    color(1,1,1), color(1,1,1), color(2,2,2), 
    color(1,1,1), color(1,1,1), color(2,2,2), 
    color(1,1,1), color(1,1,1), color(2,2,2)]
end

check ```dynamic-programming tests removing just 1 one seam```:
  liquify-dynamic-programming(
    [image(4, 4):
      color(1,1,1), color(2,2,2), color(2,2,2), color(1,1,1),
      color(3,3,3), color(3,3,3), color(4,4,4), color(5,5,5),
      color(3,3,3), color(4,4,4), color(5,5,5), color(6,6,6),
      color(7,7,7), color(8,8,8), color(9,9,9), color(10,10,10)], 1)
  is 
  [image(3, 4):
    color(2,2,2), color(2,2,2), color(1,1,1),
    color(3,3,3), color(4,4,4), color(5,5,5),
    color(3,3,3), color(5,5,5), color(6,6,6),
    color(7,7,7), color(9,9,9), color(10,10,10)]
end

check ```dynamic programming more than 1 seam```:
  liquify-dynamic-programming(
    [image(4, 4):
      color(1,1,1), color(2,2,2), color(2,2,2), color(1,1,1),
      color(3,3,3), color(3,3,3), color(4,4,4), color(5,5,5),
      color(3,3,3), color(4,4,4), color(5,5,5), color(6,6,6),
      color(7,7,7), color(8,8,8), color(9,9,9), color(10,10,10)], 2)
    is 
  [image(2, 4):
    color(2,2,2), color(1,1,1),
    color(3,3,3), color(5,5,5),
    color(3,3,3), color(6,6,6),
    color(7,7,7), color(10,10,10)]
  liquify-dynamic-programming(
    [image(5, 4):
      color(1,1,1), color(2,2,2), color(2,2,2), color(1,1,1), color(3,3,3),
      color(3,3,3), color(3,3,3), color(4,4,4), color(5,5,5), color(4,4,4),
      color(3,3,3), color(4,4,4), color(5,5,5), color(6,6,6), color(5,5,5),
      color(7,7,7), color(8,8,8), color(9,9,9), color(10,10,10), color(6,6,6)], 3)
    is 
  [image(2, 4):
    color(1, 1, 1), color(3, 3, 3),
    color(3, 3, 3), color(4, 4, 4), 
    color(3, 3, 3), color(5, 5, 5), 
    color(7, 7, 7), color(6, 6, 6)]
end

#------------------------------------------------------------------------
# Testing both Liquify-Memoization and Dynamic Programming on realistic inputs

#|

fun my-image-oracle(f1 :: (Image, Number -> Image), 
    f2 :: (Image, Number -> Image), url :: String, n :: Number) -> Boolean:
  doc: ```takes in two solutions to the fluid images problem, an image url, and a number of seams 
       to remove and outputs true if they both produce the same image and both have the 
       correct predicted height and width```
  run-on-url(url, f1, n) == run-on-url(url, f2, n)
end

check ```liquify memoization and dynamic on real inputs```:
  real-img-url-pac-man = 
    "https://avatars.mds.yandex.net/get-games/10152950/2a0000018cfe7fdbb720f5040cbdd2e5c487/pjpg128x128"
  my-image-oracle(liquify-memoization, liquify-dynamic-programming, real-img-url-pac-man, 1)
    is true
  hibiscus = 
    "https://img.thrfun.com/img/086/611/hibiscus_flower_ts2.jpg"
  my-image-oracle(liquify-memoization, liquify-dynamic-programming, real-img-url-pac-man, 2)
    is true
  flower = 
    "https://th.bing.com/th/id/R.5ec78822bf592610b36a39c0b7bfa789?rik=3FqfRvjWMrPWGg&riu=http%3a%2f%2fimpressive.net%2fpeople%2fgerald%2f2002%2f10%2f07%2f15-16-26-sq.jpg&ehk=65DAGq4dsMljPhyovO5KMlmznkZzSvOtE2Mzc4j22Lo%3d&risl=&pid=ImgRaw&r=0"
  my-image-oracle(liquify-memoization, liquify-dynamic-programming, flower, 10)
    is true
end
   
|#
   