use context essentials2020
include shared-gdrive("fluid-images-definitions.arr", "1D3kQXSwA3yVSvobr_lv7WQIwUZhGCWBp")

provide: *, type * end
# END HEADER
# DO NOT CHANGE ANYTHING ABOVE THIS LINE
#
# Write data bindings here that you'll need for tests in both
# fluid-images-code.arr and fluid-images-tests.arr

include string-dict

#|

provide *

import image-url,
image-width,
image-height,
image-to-color-list,
color-list-to-image
from image

import image-structs as I

#-------------------------------------------------------------------------

fun run-on-url(url :: String, func :: (Image, Number -> Image), n :: Number):
  doc: ```Runs one of your Fluid Images implementations on an image
       downloaded from a url```
  fl-image :: Image =
    let raw-image = image-url(url),
      width       = image-width(raw-image),
      height      = image-height(raw-image),
      image-data  = image-to-color-list(raw-image):
      image-data.map({(c):color(c.red, c.green, c.blue)})
        ^ builtins.raw-array-from-list
        ^ image(width,height).make
    end
  liquified = func(fl-image, n)
  im-list = lists.fold({(acc, cur): acc.append(cur)}, empty, liquified.pixels)
  im-list-colors = im-list.map({(e): I.color(e.red, e.green, e.blue, 1)})
  color-list-to-image(im-list-colors, liquified.width, liquified.height, 0, 0)
end
   
|#

#--------------------------------------------------------------------------------

data Coordinate:
  | coord(x :: Number, y :: Number)
end

data Seam:
  | seam(energy :: Number, path :: List<Number>)
end

fun coord-to-string(curr-coor :: Coordinate) -> String:
  doc: "converts a coordinate datatype to a string"
  x-value = curr-coor.x
  y-value = curr-coor.y 
  string-append(string-append(num-to-string(x-value), ", "), num-to-string(y-value))
where:
  coord-to-string(coord(1, 2)) is "1, 2"
  coord-to-string(coord(3, 5)) is "3, 5"
  coord-to-string(coord(5, 6)) is "5, 6"
end

# Taken and altered from 11/1 class:
fun make-memo(fctn :: (Number, Coordinate, List<List<Number>> -> Seam)): 
  memo-table = [mutable-string-dict: ]
  lam(Nergy, coor, rows):
    coordinate = coord-to-string(coor)
    SEAM = memo-table.get-now(coordinate)
    cases (Option) SEAM block:
      | some(seam-value) => seam-value
      | none =>
        leftest-lowest-nrg-seam = fctn(Nergy, coor, rows)
        memo-table.set-now(coord-to-string(coor), leftest-lowest-nrg-seam)
        leftest-lowest-nrg-seam
    end
  end
end

fun remove-idx<T>(idx :: Number, lst :: List<T>) -> List<T>:
  doc: "removes the element from the list according to the inputted idx"
  cases (List) lst:
    | empty => raise("idx out of bounds")
    | link(f, r) =>
      if idx == 0:
        r
      else:
        link(f, remove-idx(idx - 1, r))
      end
  end
where:
  remove-idx(1, [list: 1, 2, 3]) is [list: 1, 3]
  remove-idx(3, [list: 1, 2]) raises "idx out of bounds"
  remove-idx(0, [list: 1]) is empty
  remove-idx(1, [list: 0, 1]) is [list: 0]
end

fun option-get<T>(idx :: Number, lst:: List<T>) -> Option<T>:
  doc: ```gets the indexed item from the list and returns an 
       option type (none if the idx is out of bounds and some if it isn't)```
  cases (List) lst:
    | empty => none
    | link(f, r) => 
      ask:
        | idx < 0 then: none
        | idx == 0 then: some(f)
        | otherwise: option-get(idx - 1, r)
      end
  end
where:
  option-get(2, [list: 5, 6, 7]) is some(7)
  option-get(1, [list: 5, 6, 7]) is some(6)
  option-get(0, [list: 8, 9]) is some(8)
  option-get(3, [list: 10, 11]) is none
  option-get(-1, [list: 6, 1]) is none
  option-get(-5, [list: 7, 8]) is none
end