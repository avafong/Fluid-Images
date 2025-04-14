use context essentials2020
include shared-gdrive("fluid-images-definitions.arr", "1D3kQXSwA3yVSvobr_lv7WQIwUZhGCWBp")

provide: liquify-memoization, liquify-dynamic-programming end

include my-gdrive("fluid-images-common.arr")
# END HEADER
# DO NOT CHANGE ANYTHING ABOVE THIS LINE
#
# You may write implementation-specific tests (e.g., of helper functions)
# in this file.

include string-dict

#---------------------------------------------------------------------------------------------------
# Developing convert-to-nrg

# Defining Helpers for convert-to-nrg:

# ABC
# DEF
# GHI
fun nrg-convert(pnt :: Coordinate, rows :: List<List<Color>>) -> Number:
  doc: ```given a point corresponding a pixel location in the image, computes that pixel's nrg in 
       context of the given rows```
  x-pnt = pnt.x
  y-pnt = pnt.y
  A-bri = get-brightness(coord(x-pnt - 1, y-pnt - 1), rows) #A 
  B-bri = get-brightness(coord(x-pnt, y-pnt - 1), rows) # B
  C-bri= get-brightness(coord(x-pnt + 1, y-pnt - 1), rows) #C
  D-bri = get-brightness(coord(x-pnt - 1, y-pnt), rows) # D
  F-bri = get-brightness(coord(x-pnt + 1, y-pnt), rows)
  G-bri = get-brightness(coord(x-pnt - 1, y-pnt + 1), rows) #G
  H-bri = get-brightness(coord(x-pnt, y-pnt + 1), rows) #H
  I-bri = get-brightness(coord(x-pnt + 1, y-pnt + 1), rows) #I 
  x-nrg = 
    (A-bri + (2 * D-bri) + G-bri) - (C-bri) - (2 * F-bri) - (I-bri)
  y-nrg = 
    (A-bri + (2 * B-bri) +  C-bri) - (G-bri) - (2 * H-bri) - (I-bri)
  num-sqrt(num-sqr(x-nrg) + num-sqr(y-nrg))
where:
  test-img = 
    [list: 
      [list: color(1,1,1), color(2,2,2), color(3,3,3)],
      [list: color(4,4,4), color(5,5,5), color(6,6,6)],
      [list: color(7,7,7), color(8,8,8), color(9,9,9)]]
  nrg-convert(coord(0,0), test-img) is-roughly num-sqrt(num-sqr(27) + num-sqr(39))
  nrg-convert(coord(0,1), test-img) is-roughly num-sqrt(num-sqr(60) + num-sqr(54))
  nrg-convert(coord(1,1), test-img) is-roughly num-sqrt(num-sqr(72) + num-sqr(24))
  nrg-convert(coord(2,0), test-img) is-roughly num-sqrt(num-sqr(51) + num-sqr(27))
  nrg-convert(coord(2,1), test-img) is-roughly num-sqrt(num-sqr(54) + num-sqr(60))
  nrg-convert(coord(1,0), test-img) is-roughly num-sqrt(num-sqr(18) + num-sqr(60))
end

fun get-brightness(pnt :: Coordinate, rows :: List<List<Color>>) -> Number:
  doc: ```takes in a pixel location and calculates the brightness of that pixel. 
       If the pixel location does not exist, the 'brightness' treated as 0.```
  cases (Option) option-get(pnt.y, rows): # get specific row
    | none => 0
    | some(specific-row) => 
      cases (Option) option-get(pnt.x, specific-row):
        | none => 0
        | some(clr) => combine-brightness(clr)
      end
  end
where:
  test-img = 
    [list: 
      [list: color(1,1,1), color(2,2,2), color(3,3,3)],
      [list: color(4,4,4), color(5,5,5), color(6,6,6)],
      [list: color(7,7,7), color(8,8,8), color(9,9,9)]]
  get-brightness(coord(0,0), test-img) is 3
  get-brightness(coord(1,0), test-img) is 6
  get-brightness(coord(2,0), test-img) is 9
  get-brightness(coord(3,0), test-img) is 0
  get-brightness(coord(0,3), test-img) is 0
  get-brightness(coord(3,3), test-img) is 0
  get-brightness(coord(2,2), test-img) is 27
  get-brightness(coord(1,-1), test-img) is 0
end

check "compute-row-nrg tests":
  test-img = 
    [list: 
      [list: color(1,1,1), color(2,2,2), color(3,3,3)],
      [list: color(4,4,4), color(5,5,5), color(6,6,6)],
      [list: color(7,7,7), color(8,8,8), color(9,9,9)]]
  test-img-2-rows = 
     [list: 
      [list: color(1,1,1), color(2,2,2), color(3,3,3)],
      [list: color(4,4,4), color(5,5,5), color(6,6,6)]]
  test-img-1-row = 
    [list: 
      [list: color(1,1,1), color(2,2,2), color(3,3,3)]]
  compute-row-nrg(coord(2,0), test-img, empty) 
  is-roughly
  [list: 
    nrg-convert(coord(0,0), test-img),
    nrg-convert(coord(1,0), test-img),
    nrg-convert(coord(2,0), test-img)]
  compute-row-nrg(coord(2,1), test-img, empty)
  is-roughly
  [list: 
    nrg-convert(coord(0,1), test-img),
    nrg-convert(coord(1,1), test-img),
    nrg-convert(coord(2,1), test-img)]
  compute-row-nrg(coord(1,0), test-img, [list: nrg-convert(coord(2,0), test-img)])
    is-roughly 
  [list: 
    nrg-convert(coord(0,0), test-img),
    nrg-convert(coord(1,0), test-img),
    nrg-convert(coord(2,0), test-img)]
  compute-row-nrg(coord(2,0), test-img-2-rows, empty)
    is-roughly 
  [list: 
    nrg-convert(coord(0,0), test-img-2-rows),
    nrg-convert(coord(1,0), test-img-2-rows),
    nrg-convert(coord(2,0), test-img-2-rows)]
  compute-row-nrg(coord(2,1), test-img-2-rows, empty)
    is-roughly 
  [list: 
    nrg-convert(coord(0,1), test-img-2-rows),
    nrg-convert(coord(1,1), test-img-2-rows),
    nrg-convert(coord(2,1), test-img-2-rows)]
  compute-row-nrg(coord(2,0), test-img-1-row, empty)
    is 
  [list: 
    nrg-convert(coord(0,0), test-img-1-row),
    nrg-convert(coord(1,0), test-img-1-row),
    nrg-convert(coord(2,0), test-img-1-row)]
end

fun compute-row-nrg(pnt :: Coordinate, rows :: List<List<Color>>, 
    curr-nrgs :: List<Number>) -> List<Number>:
  doc: ```is given a starting coordinate corresponding to a pixel along the right edge of 
       the image and computes that corresponding of energies that represent the energy 
       of that row```
  depth = pnt.y
  row-now = rows.get(depth) # gets the row we are interested in
  if pnt.x == 0:
    link(nrg-convert(coord(0, depth), rows), curr-nrgs)
  else:
    compute-row-nrg(
      coord(pnt.x - 1, depth), 
      rows, 
      link(nrg-convert(pnt, rows), curr-nrgs))
  end
end

fun combine-brightness(clr :: Color) -> Number:
  doc: "takes in a pixel's color and adds up the brightness values for the different channels"
  clr.red + clr.green + clr.blue
where:
  combine-brightness(color(0,1,2)) is 3
  combine-brightness(color(0,0,0)) is 0
  combine-brightness(color(1,1,1)) is 3
end

fun get-top-2(clrs :: List<List<Color>>) -> List<List<Color>>:
  doc: ```gets the top two rows from an image. Returns an empty 
       list if input list is empty, and a list of one row if there is only one row in the image```
  cases (List) clrs:
    | empty => empty 
    | link(first-row, rest-rows) => 
      cases (List) rest-rows:
        | empty => [list: first-row]
        | link(fr, rr) => 
          link(first-row, [list: fr])
      end
  end
where:
  get-top-2(
    [list: 
      [list: color(0,0,0), color(0,0,0), color(0,0,0)],
      [list: color(1,1,1), color(1,1,1), color(1,1,1)]])
    is 
  [list: 
    [list: color(0,0,0), color(0,0,0), color(0,0,0)],
    [list: color(1,1,1), color(1,1,1), color(1,1,1)]]
  get-top-2(
    [list: 
      [list: color(0,0,0), color(0,0,0), color(0,0,0)],
      [list: color(1,1,1), color(1,1,1), color(1,1,1)],
      [list: color(2,2,2), color(2,2,2), color(2,2,2)]])
    is 
  [list: 
    [list: color(0,0,0), color(0,0,0), color(0,0,0)],
    [list: color(1,1,1), color(1,1,1), color(1,1,1)]]
  get-top-2(
    [list: 
      [list: color(0,0,0), color(0,0,0), color(0,0,0)]])
    is 
  [list: 
      [list: color(0,0,0), color(0,0,0), color(0,0,0)]]
  get-top-2(
    [list: ])
    is empty
end

fun recalculate-nrg(rows :: List<List<Color>>) -> List<List<Number>>: 
  doc: ```calculates the energy of the rows of colors it is 
       given and outputs a 2d list of numbers representing energies. Note: the function always 
       outputs a maximum of two rows of numbers```
  cases (List) rows:
    | empty =>  raise("recalculate-nrg should not be passed an empty image") 
    | link(first-row, rest-rows) =>
      starting-x-idx = first-row.length() - 1
      cases (List) rest-rows:
        | empty => # case where recalculate is only passed a single row: 
          [list: 
            compute-row-nrg(coord(starting-x-idx, 0), rows, empty)]
        | link(f-rest, r-rest) => # case where recalculate is passed two or three rows:
           [list:
              compute-row-nrg(coord(starting-x-idx, 0), rows, empty), 
              compute-row-nrg(coord(starting-x-idx, 1), rows, empty)] 
      end
  end
where:
  test-img = 
    [list: 
      [list: color(1,1,1), color(2,2,2), color(3,3,3)],
      [list: color(4,4,4), color(5,5,5), color(6,6,6)],
      [list: color(7,7,7), color(8,8,8), color(9,9,9)]]
  test-img-2-rows = 
    [list: 
      [list: color(1,1,1), color(2,2,2), color(3,3,3)],
      [list: color(4,4,4), color(5,5,5), color(6,6,6)]]
  test-img-1-row = [list: [list: color(1,1,1), color(2,2,2), color(3,3,3)]]
  
  recalculate-nrg(test-img) 
  is-roughly
  [list: 
    [list: 
      nrg-convert(coord(0,0), test-img), 
      nrg-convert(coord(1,0), test-img), 
      nrg-convert(coord(2,0), test-img)],
    [list: 
      nrg-convert(coord(0,1), test-img), 
      nrg-convert(coord(1,1), test-img), 
      nrg-convert(coord(2,1), test-img)]]
  
  recalculate-nrg(test-img-2-rows)
    is-roughly 
  [list: 
    [list: 
      nrg-convert(coord(0,0), test-img-2-rows), 
      nrg-convert(coord(1,0), test-img-2-rows), 
      nrg-convert(coord(2,0), test-img-2-rows)],
    [list: 
      nrg-convert(coord(0,1), test-img-2-rows), 
      nrg-convert(coord(1,1), test-img-2-rows), 
      nrg-convert(coord(2,1), test-img-2-rows)]]
  recalculate-nrg(test-img-1-row)
  is-roughly 
  [list: 
    [list: 
      nrg-convert(coord(0,0), test-img-1-row), 
      nrg-convert(coord(1,0), test-img-1-row), 
      nrg-convert(coord(2,0), test-img-1-row)]]
end

# Defining convert-to-nrg:

fun convert-to-nrg(pixels :: List<List<Color>>) -> List<List<Number>>:
  doc: ```converts given pixels from an image to a 2d list of numbers representing the same image 
       but with the pixels converted to energies```
  cases (List) pixels:
    | empty => empty
    | link(first-row, rest-rows) => 
      # use recursion to calculate the rest of the image, but you are forced to keep 'recalculating'
      # the top row of the converted rest because it is affected by the first-row that you
      # add above it. 
      cases (List) convert-to-nrg(rest-rows):
        | empty => recalculate-nrg([list: first-row] + get-top-2(rest-rows))
        | link(_, converted-rest) => 
          recalculate-nrg([list: first-row] + get-top-2(rest-rows)) + converted-rest
      end
  end
where:
  test-pxls =
    [list:
      [list: color(1,1,1), color(2,2,2),  color(3,3,3)],
      [list: color(4,4,4), color(5,5,5),  color(6,6,6)],
      [list: color(7,7,7), color(8,8,8), color(9,9,9)]]
  convert-to-nrg(test-pxls) is-roughly
  [list: 
    [list: 
      nrg-convert(coord(0,0), test-pxls), 
      nrg-convert(coord(1,0), test-pxls), 
      nrg-convert(coord(2,0), test-pxls)], 
    [list: 
      nrg-convert(coord(0,1), test-pxls), 
      nrg-convert(coord(1,1), test-pxls), 
      nrg-convert(coord(2,1), test-pxls)], 
    [list: 
      nrg-convert(coord(0,2), test-pxls), 
      nrg-convert(coord(1,2), test-pxls), 
      nrg-convert(coord(2,2), test-pxls)]]
  test-pxls-1-row = 
    [list:
      [list: color(1,1,1), color(2,2,2), color(3,3,3)]]
  convert-to-nrg(test-pxls-1-row) is-roughly 
  [list: 
    [list: 
      nrg-convert(coord(0,0), test-pxls-1-row), 
      nrg-convert(coord(1,0), test-pxls-1-row), 
      nrg-convert(coord(2,0), test-pxls-1-row)]]
end

test-nrg = 
  convert-to-nrg(
  [list: 
    [list: color(1,1,1), color(2,2,2), color(3,3,3)],
    [list: color(4,4,4), color(5,5,5), color(6,6,6)],
    [list: color(7,7,7), color(8,8,8), color(9,9,9)]])

test-nrg-2 = 
  convert-to-nrg(
    [list: 
      [list: color(2,2,2), color(1,1,1), color(1,1,1), color(2,2,2)],
      [list: color(2,2,2), color(1,1,1), color(1,1,1), color(2,2,2)],
      [list: color(2,2,2), color(1,1,1), color(1,1,1), color(2,2,2)],
      [list: color(2,2,2), color(1,1,1), color(1,1,1), color(2,2,2)]])

test-nrgies = convert-to-nrg(
  [list:
    [list: color(1,1,1), color(2,2,2), color(2,2,2), color(1,1,1)],
    [list: color(3,3,3), color(3,3,3), color(4,4,4), color(5,5,5)],
    [list: color(3,3,3), color(4,4,4), color(5,5,5), color(6,6,6)],
    [list: color(7,7,7), color(8,8,8), color(9,9,9), color(10,10,10)]])

two-columns = 
  [image(2, 5):
    color(1,1,1), color(2,2,2),
    color(2,2,2), color(2,2,2), 
    color(3,3,3), color(3,3,3),
    color(5,5,5), color(2,2,2), 
    color(1,1,1), color(1,1,1)]

#---------------------------------------------------------------------------------------------------
# Developing Liquidfy-memoization:

fun liquify-memoization(img :: Image, n :: Number) -> Image:
  pxls = img.pixels
  fun liquify-memoization-helper(curr-pxls :: List<List<Color>>, 
      idx :: Number) -> List<List<Color>>:
    nrg-info-memo = convert-to-nrg(curr-pxls)
    rec find-lowest-nrg-seam-from-pxl = 
      make-memo(
        lam(nrg :: Number, curr-coord :: Coordinate, 
            below-rows :: List<List<Number>>):
          cases (List) below-rows:
            | empty =>
              seam(nrg, [list: curr-coord.x])
            | link(first-row-below, rest-rows) =>
              cases (Option) option-get(curr-coord.x, first-row-below):
                | none => raise(
                    ```should't get here: if the below rows are guaranteed to be linked, 
                then there should always be a below-nrg present```)
                | some(below-nrg) => 
                  # look at diagonal right
                  cases (Option) option-get(curr-coord.x + 1, first-row-below):
                    | none => # no diagonal right pixel: 
                      # look at diagonal left:
                      cases (Option) option-get(curr-coord.x - 1, first-row-below): 
                        | none => # case where there are no diagonally adjacent pixels
                          best-seam-below = 
                            find-lowest-nrg-seam-from-pxl(
                              below-nrg, coord(curr-coord.x, curr-coord.y + 1), rest-rows)
                          seam(nrg + best-seam-below.energy, 
                            link(curr-coord.x, best-seam-below.path))
                        | some(left-nrg) => # case where there is only a diagonal left and a 
                          #below pixel. Look at the lowest nrg seams stemming from the two pixels 
                          # below, and pick the # lowest nrg, leftmost seam: 
                          best-seam-below = 
                            get-lowest-left-most-seam(
                              [list: 
                                find-lowest-nrg-seam-from-pxl(
                                  below-nrg, coord(curr-coord.x, curr-coord.y + 1), rest-rows),
                                find-lowest-nrg-seam-from-pxl(
                                  left-nrg, coord(curr-coord.x - 1, curr-coord.y + 1), rest-rows)])
                          seam(nrg + best-seam-below.energy,
                            link(curr-coord.x, best-seam-below.path))
                      end
                    | some(right-nrg) => # diagonal right pixel exists:
                      cases (Option) option-get(curr-coord.x - 1, first-row-below):
                        | none => # case where there is only a diagonal right and a below pixel
                          best-seam-below = 
                            get-lowest-left-most-seam(
                              [list: 
                                find-lowest-nrg-seam-from-pxl(
                                  below-nrg, coord(curr-coord.x, curr-coord.y + 1), rest-rows),
                                find-lowest-nrg-seam-from-pxl(
                                  right-nrg, coord(curr-coord.x + 1, curr-coord.y + 1), rest-rows)])
                          seam(nrg + best-seam-below.energy, 
                            link(curr-coord.x, best-seam-below.path))
                        | some(left-nrg) => # case where there is are both 
                          # diagonally adjacent pixels and a below pixel:
                          best-seam-below =
                            get-lowest-left-most-seam(
                              [list: 
                                find-lowest-nrg-seam-from-pxl(
                                  below-nrg, coord(curr-coord.x, curr-coord.y + 1), rest-rows), 
                                find-lowest-nrg-seam-from-pxl(
                                  right-nrg, coord(curr-coord.x + 1, curr-coord.y + 1), rest-rows), 
                                find-lowest-nrg-seam-from-pxl(
                                  left-nrg, coord(curr-coord.x - 1, curr-coord.y + 1), rest-rows)])
                          seam(nrg + best-seam-below.energy, 
                            link(curr-coord.x, best-seam-below.path))
                      end
                  end
              end
          end
        end)
    if idx == 0:
      curr-pxls
    else:
      remove-this-seam-memo = memo-get-seam(nrg-info-memo, find-lowest-nrg-seam-from-pxl)
      new-img-pxls-memo = remove-seam-from-pxls(remove-this-seam-memo, curr-pxls)
      liquify-memoization-helper(new-img-pxls-memo, idx - 1)
    end
  end
  image-data-to-image(
    img.width - n,
    img.height,
    liquify-memoization-helper(pxls, n))
end

fun remove-seam-from-pxls(seam-1 :: Seam, pxls :: List<List<Color>>) -> List<List<Color>>:
  doc: "given a seam and pxls, removes the apporpriate pixels from the img"
  map2(
    {(idx, nrg-row): remove-idx(idx, nrg-row)},
    seam-1.path,
    pxls)
where:
  remove-seam-from-pxls(
    seam(11, [list: 0, 1, 2, 1]),
    [list: 
      [list: color(1,1,1), color(2,2,2), color(3,3,3), color(4,4,4)],
      [list: color(2,2,2), color(5,5,5), color(6,6,6), color(7,7,7)],
      [list: color(8,8,8), color(9,9,9), color(3,3,3), color(4,4,4)],
      [list: color(1,1,1), color(2,2,2), color(3,3,3), color(4,4,4)]])
    is 
  [list: 
    [list: color(2,2,2), color(3,3,3), color(4,4,4)],
    [list: color(2,2,2), color(6,6,6), color(7,7,7)],
    [list: color(8,8,8), color(9,9,9), color(4,4,4)],
    [list: color(1,1,1), color(3,3,3), color(4,4,4)]]
end

# this function is analgous to find-lowest-nrg-seam-from-pxl with just the name changed and is
# being defined outside of the context of liquify-memoization 
# to use for the testing of liquify-memoization's helper functions:
rec find-lowest-nrg-seam-from-pxl-for-testing = 
      make-memo(
        lam(nrg :: Number, curr-coord :: Coordinate, 
            below-rows :: List<List<Number>>):
          cases (List) below-rows:
            | empty =>
              seam(nrg, [list: curr-coord.x])
            | link(first-row-below, rest-rows) =>
              cases (Option) option-get(curr-coord.x, first-row-below):
                | none => raise(
                    ```should't get here: if the below rows are guaranteed to be linked, 
                then there should always be a below-nrg present```)
                | some(below-nrg) => 
                  # look at diagonal right
                  cases (Option) option-get(curr-coord.x + 1, first-row-below):
                    | none => # no diagonal right pixel: 
                      # look at diagonal left:
                      cases (Option) option-get(curr-coord.x - 1, first-row-below): 
                        | none => # case where there are no diagonally adjacent pixels
                          best-seam-below = 
                            find-lowest-nrg-seam-from-pxl-for-testing(
                              below-nrg, coord(curr-coord.x, curr-coord.y + 1), rest-rows)
                          seam(nrg + best-seam-below.energy, 
                            link(curr-coord.x, best-seam-below.path))
                        | some(left-nrg) => # case where there is only a diagonal left and a 
                          #below pixel. Look at the lowest nrg seams stemming from the two pixels 
                          # below, and pick the # lowest nrg, leftmost seam: 
                          best-seam-below = 
                            get-lowest-left-most-seam(
                              [list: 
                                find-lowest-nrg-seam-from-pxl-for-testing(
                                  below-nrg, coord(curr-coord.x, curr-coord.y + 1), rest-rows),
                                find-lowest-nrg-seam-from-pxl-for-testing(
                                  left-nrg, coord(curr-coord.x - 1, curr-coord.y + 1), rest-rows)])
                          seam(nrg + best-seam-below.energy,
                            link(curr-coord.x, best-seam-below.path))
                      end
                    | some(right-nrg) => # diagonal right pixel exists:
                      cases (Option) option-get(curr-coord.x - 1, first-row-below):
                        | none => # case where there is only a diagonal right and a below pixel
                          best-seam-below = 
                            get-lowest-left-most-seam(
                              [list: 
                                find-lowest-nrg-seam-from-pxl-for-testing(
                                  below-nrg, coord(curr-coord.x, curr-coord.y + 1), rest-rows),
                                find-lowest-nrg-seam-from-pxl-for-testing(
                                  right-nrg, coord(curr-coord.x + 1, curr-coord.y + 1), rest-rows)])
                          seam(nrg + best-seam-below.energy, 
                            link(curr-coord.x, best-seam-below.path))
                        | some(left-nrg) => # case where there is are both 
                          # diagonally adjacent pixels and a below pixel:
                          best-seam-below =
                            get-lowest-left-most-seam(
                              [list: 
                                find-lowest-nrg-seam-from-pxl-for-testing(
                                  below-nrg, coord(curr-coord.x, curr-coord.y + 1), rest-rows), 
                                find-lowest-nrg-seam-from-pxl-for-testing(
                                  right-nrg, coord(curr-coord.x + 1, curr-coord.y + 1), rest-rows), 
                                find-lowest-nrg-seam-from-pxl-for-testing(
                                  left-nrg, coord(curr-coord.x - 1, curr-coord.y + 1), rest-rows)])
                          seam(nrg + best-seam-below.energy, 
                            link(curr-coord.x, best-seam-below.path))
                  end
              end
          end
      end
    end)

fun memo-get-seam(energies:: List<List<Number>>, 
    memoized-get-seam-func :: (Number, Coordinate, 
      List<List<Number>> -> Seam)) -> Seam:
  doc: ```takes in a 2d list of numbers representing an image's energies and 
       finds the lowest energy leftmost seam using memoization```
  memo-seam-contenders = lowest-seam-contenders(energies, memoized-get-seam-func)
  get-lowest-left-most-seam(memo-seam-contenders)
where:
  memo-get-seam([list: 
      [list: 1, 5, 6, 7],
      [list: 8, 7, 4, 3],
      [list: 5, 3, 2, 1],
      [list: 5, 1, 2, 4]],
    find-lowest-nrg-seam-from-pxl-for-testing)
    is seam(11, [list: 0, 1, 2, 1])
end

fun lowest-seam-contenders(energies :: List<List<Number>>, 
    memoized-get-seam-fun :: (Number, Coordinate, 
      List<List<Number>> -> Seam)) -> List<Seam>:
  doc: ```Using memoization, takes in a 2d list of numbers representing an image's energies 
       and creates a list of candidate lowest nrg seams from each pixel on the top of the image
       down to the bottom. Note the length of the list will equal the width of the img```
  cases (List) energies:
    | empty => raise(```memo-contender-seams shouldn't be passed empty energies--
        implying an empty img```)
    | link(first-row, rest-rows) =>
      get-contender-seams(first-row, coord(0,0), rest-rows, memoized-get-seam-fun)
  end
where:
  lowest-seam-contenders(
    [list: 
      [list: 1, 5, 6, 7],
      [list: 8, 7, 4, 3],
      [list: 5, 3, 2, 1],
      [list: 5, 1, 2, 4]], 
    find-lowest-nrg-seam-from-pxl-for-testing)
    is 
  [list: 
    seam(1 + 7 + 2 + 1, [list: 0, 1, 2, 1]), 
    seam(5 + 4 + 2 + 1, [list: 1, 2, 2, 1]), 
    seam(6 + 3 + 2 + 1, [list: 2, 3, 2, 1]), 
    seam(7 + 3 + 2 + 1, [list: 3, 3, 2, 1])]
end

fun get-contender-seams(first-row :: List<Number>, curr-coord :: Coordinate,
    below-rows :: List<List<Number>>, 
    memoized-get-seam-fun :: (Number, Coordinate, 
      List<List<Number>> -> Seam)) -> List<Seam>:
  doc: ```takes in an top row of nrgies, an initial coordinate, and a list of nrgies representing 
       the energies of the pixels below the top row and outputs a list of 
       lowest-nrg, leftmost seams from each top-row pixel going to the bottom of the img```
  cases (List) first-row: 
    | empty => empty 
    | link(first-nrg, rest-nrgies) =>
      new-coordinate = coord(curr-coord.x + 1, curr-coord.y)
      link(
        memoized-get-seam-fun(first-nrg, curr-coord, below-rows), 
        get-contender-seams(rest-nrgies, new-coordinate, below-rows, memoized-get-seam-fun))
    end
where:
  get-contender-seams(
    [list: 1, 5, 6, 7], coord(0,0), 
    [list: 
      [list: 8, 7, 4, 3],
      [list: 5, 3, 2, 1],
      [list: 5, 1, 2, 4]], 
    find-lowest-nrg-seam-from-pxl-for-testing)
    is 
  [list: 
    seam(1 + 7 + 2 + 1, [list: 0, 1, 2, 1]), 
    seam(5 + 4 + 2 + 1, [list: 1, 2, 2, 1]), 
    seam(6 + 3 + 2 + 1, [list: 2, 3, 2, 1]), 
    seam(7 + 3 + 2 + 1, [list: 3, 3, 2, 1])]
  get-contender-seams(
    [list: 5, 6, 7], coord(1,0), 
    [list: 
      [list: 8, 7, 4, 3],
      [list: 5, 3, 2, 1],
      [list: 5, 1, 2, 4]], 
    find-lowest-nrg-seam-from-pxl-for-testing)
    is 
  [list: 
    seam(5 + 4 + 2 + 1, [list: 1, 2, 2, 1]), 
    seam(6 + 3 + 2 + 1, [list: 2, 3, 2, 1]), 
    seam(7 + 3 + 2 + 1, [list: 3, 3, 2, 1])]
end

# find-lowest-nrg-seam-from-pxl-testing takes in a nrg number, its location along the 
# width of the image (the current coordinate), and the nrg values below and determines the
# lowest nrg, leftmost seam to the bottom of the img from that pxl location```
check "find-lowest-nrg-seam-from-pxl-for-testing":
  find-lowest-nrg-seam-from-pxl-for-testing(
    1, coord(0,0), 
    [list:  
      [list: 8, 7, 4, 3],
      [list: 5, 3, 2, 1],
      [list: 5, 1, 2, 4]]) is 
  seam(1 + 7 + 2 + 1, [list: 0, 1, 2, 1])
  find-lowest-nrg-seam-from-pxl-for-testing(
    5, coord(1,0), 
    [list:  
      [list: 8, 7, 4, 3],
      [list: 5, 3, 2, 1],
      [list: 5, 1, 2, 4]]) is 
  seam(5 + 4 + 2 + 1, [list: 1, 2, 2, 1])
  find-lowest-nrg-seam-from-pxl-for-testing(
    6, coord(2,0), 
    [list: 
      [list: 8, 7, 4, 3],
      [list: 5, 3, 2, 1],
      [list: 5, 1, 2, 4]]) is 
  seam(6 + 3 + 2 + 1, [list: 2, 3, 2, 1])
  find-lowest-nrg-seam-from-pxl-for-testing(
    7, coord(3,0), 
    [list: 
      [list: 8, 7, 4, 3],
      [list: 5, 3, 2, 1],
      [list: 5, 1, 2, 4]]) is
  seam(7 + 3 + 2 + 1, [list: 3, 3, 2, 1])
end

fun get-lowest-left-most-seam(seams :: List<Seam>) -> Seam:
  doc: ```takes in a list of same-length, qualitatively different seams and extracts the 
       lowest nrg seam. If there is a tie in nrgies, gets the leftmost seam```
  cases (List) seams:
    | empty => raise("get-lowest-left-most-seam shouldn't be passed an empty list of seams")
    | link(first-seam, rest-seams) =>
      cases (List) rest-seams:
        | empty => first-seam # if there's only one seam in the list left the 
          # first-seam is the only option
        | link(_,_) => 
          rest-best-seam =  get-lowest-left-most-seam(rest-seams)
          nrg-rest-best-seam = rest-best-seam.energy
          nrg-of-first-seam = first-seam.energy
          ask:
            | nrg-of-first-seam < nrg-rest-best-seam then: first-seam
            | num-within-rel(0.00000000000001)(nrg-of-first-seam, nrg-rest-best-seam) then:
              if lefter(first-seam.path, rest-best-seam.path):
                first-seam
              else:
                rest-best-seam
              end
            | nrg-of-first-seam > nrg-rest-best-seam then: rest-best-seam
          end
      end
  end
where:
  get-lowest-left-most-seam([list: seam(5, [list: 0, 1, 2, 3])]) 
    is seam(5, [list: 0, 1, 2, 3])
  get-lowest-left-most-seam(
    [list: 
      seam(5, [list: 3, 2]), seam(3, [list: 1, 2]), seam(7, [list: 2, 1]), 
      seam(7, [list: 6, 7])])
    is seam(3, [list: 1, 2])
  get-lowest-left-most-seam(
    [list: 
      seam(3, [list: 3, 2]), seam(3, [list: 1, 2]), seam(7, [list: 2, 1]), 
      seam(7, [list: 6, 7])])
    is seam(3, [list: 1, 2])
  get-lowest-left-most-seam(
    [list: 
      seam(3, [list: 1, 2]), seam(3, [list: 1, 3]), seam(7, [list: 2, 1]), 
      seam(7, [list: 6, 7])])
    is seam(3, [list: 1, 2])
  get-lowest-left-most-seam(empty) raises 
  "get-lowest-left-most-seam shouldn't be passed an empty list of seams"
end


fun lefter(seam-path1 :: List<Number>, seam-path2 :: List<Number>) -> Boolean:
  doc: ```takes in two qualitatively different seam paths of the same length represented by 
       lists of numbers and if the first path (seam-path1)offers a more left path than the 
       second path, outputs true. Otherwise, outputs false```
  cases (List) seam-path1:
    | empty =>
      cases (List) seam-path2:
        | empty => 
          raise(```lefter is guaranteed two qualitatively different seam paths and shouldn't 
                get to the empty case of the two paths before outputting a boolean```)
        | link(first-path2, rest-path2) => raise("lefter should be passed seams of the same length")
      end
    | link(first-path1, rest-path1) =>
      cases (List) seam-path2:
        | empty => raise("lefter should be passed seams of the same length")
        | link(first-path2, rest-path2) => 
          ask: 
            | first-path1 < first-path2 then: true
            | first-path1 == first-path2 then: 
              lefter(rest-path1, rest-path2)
            | first-path1 > first-path2 then: false
          end
      end
  end
where:
  lefter([list: 0, 0, 0, 0], [list: 0, 1, 2, 3]) is true
  lefter([list: 0, 0, 0, 1], [list: 0, 0, 0, 2]) is true
  lefter([list: 1, 2, 3], [list: 2, 3, 4]) is true
  lefter([list: 4, 3, 3], [list: 3, 1, 2]) is false
  lefter([list: 4], [list: 5]) is true
  lefter([list: 5], [list: 4]) is false
  lefter([list: 3, 4], [list: 3, 4, 4]) raises "lefter should be passed seams of the same length"
  lefter([list: 3, 4, 5], [list: 3, 4]) raises "lefter should be passed seams of the same length"
end

#------------------------------------------------------------------------------------------------
# Developing Dynamic-programming

fun liquify-dynamic-programming(img :: Image, n :: Number) -> Image:
  pxls = img.pixels
  fun liquify-dynamic-programming-helper(curr-pxls :: List<List<Color>>, 
      idx :: Number) -> List<List<Color>>:
    nrg-info-dyn = convert-to-nrg(curr-pxls)
    if idx == 0:
      curr-pxls
    else:
      remove-this-seam-dynamic = dynamic-get-seam(nrg-info-dyn)
      new-pxls = remove-seam-from-pxls(remove-this-seam-dynamic, curr-pxls)
      liquify-dynamic-programming-helper(new-pxls, idx - 1)
    end
  end
  image-data-to-image(
    img.width - n,
    img.height,
    liquify-dynamic-programming-helper(pxls, n))
end
  
fun dynamic-get-seam(energies :: List<List<Number>>) -> Seam:
  doc: ```takes in a 2d list of numbers representing an image's energies and 
       finds the lowest energy leftmost seam using dyanmic programming```
  dyn-seam-contenders = dynamic-contender-seams(energies)
  get-lowest-left-most-seam(dyn-seam-contenders)
where:
  dynamic-get-seam(
    [list:
      [list: 1, 5, 6, 7],
      [list: 8, 7, 4, 3],
      [list: 5, 3, 2, 1],
      [list: 5, 1, 2, 4]])
    is 
  seam(11, [list: 0, 1, 2, 1])
  dynamic-get-seam(
    [list:
      [list: 1, 5, 6, 7]])
    is 
  seam(1, [list: 0])
end

fun dynamic-contender-seams(energies :: List<List<Number>>) -> List<Seam>:
  doc: ```Using dynamic programming, takes in a 2d list of numbers representing an image's 
         energies and creates a list of of seams that are candidates for the lowest possible 
         energy seam. Note: the output list of seams will have the same length as 
         the 'width' of the img.```
    bottom-up-energies = energies.reverse() # reverse it so we can work from the bottom up
    cases (List) bottom-up-energies:
      | empty => raise("dynamic-contender seams shouldn't be passed an empty 2d list of nrgs")
      | link(bottom-row, above-rows) =>
      initialized-bottom = 
        initialize(bottom-row, 0) # initialize the bottom row energies as a seams
      cases (List) above-rows:
        | empty => # case where the image is only 1 row of pixels tall. 
          initialized-bottom 
        | link(_,_) =>  # case where the image is more than 1 row of pixels tall.
          build-contender-seams(above-rows, initialized-bottom)
      end
  end
where:
  dynamic-contender-seams(
    [list:
      [list: 1, 5, 6, 7],
      [list: 8, 7, 4, 3],
      [list: 5, 3, 2, 1],
      [list: 5, 1, 2, 4]])
    is 
  [list: 
    seam(11, [list: 0, 1, 2, 1]),
    seam(12, [list: 1, 2, 2, 1]),
    seam(12, [list: 2, 3, 2, 1]),
    seam(13, [list: 3, 3, 2, 1])]
  dynamic-contender-seams(
    [list: 
      [list: 1, 5, 6, 7],
      [list: 8, 7, 4, 3],
      [list: 5, 3, 2, 1]])
    is 
  [list:
    seam(10, [list: 0, 1, 2]),
    seam(10, [list: 1, 2, 3]),
    seam(10, [list: 2, 3, 3]),
    seam(11, [list: 3, 3, 3])]
  dynamic-contender-seams(
    [list: 
      [list: 1, 5, 6, 7]])
    is 
  [list:
    seam(1, [list: 0]),
    seam(5, [list: 1]), 
    seam(6, [list: 2]), 
    seam(7, [list: 3])]
end

fun build-contender-seams(above-rows :: List<List<Number>>, 
    below-seams :: List<Seam>) -> List<Seam>:
  doc: ```builds candidate lowest-nrg seams using the inputted rows of energies and 
       the initial bottom seams at the bottom of the image```
  cases (List) above-rows:
    | empty => 
      below-seams
    | link(next-up-row, rest-rows) =>
      new-below-seams = build-new-seams(next-up-row, 0, below-seams)
      build-contender-seams(rest-rows, new-below-seams)
  end
where:
  initial-below-seams = 
    [list: seam(1, [list: 0]), seam(2, [list: 1]), seam(3, [list: 2]), seam(4, [list: 3])]
  build-contender-seams(
    [list: 
      [list: 8, 7, 6, 5],
      [list: 9, 10, 11, 12],
      [list: 16, 15, 14, 13]],
    initial-below-seams)
    is
  [list: 
    seam(16 + 9 + 7 + 1, [list: 0, 0, 1, 0]), 
    seam(15 + 9 + 7 + 1, [list: 1, 0, 1, 0]), 
    seam(14 + 10 + 7 + 1, [list: 2, 1, 1, 0]), 
    seam(13 + 11 + 7 + 1, [list: 3, 2, 1, 0])]
  initial-below-seams-2 = 
    [list: 
      seam(1, [list: 0]), 
      seam(2, [list: 1]), 
      seam(3, [list: 2]), 
      seam(4, [list: 3])]
  build-contender-seams(
    [list: 
      [list: 4, 3, 2, 1], 
      [list: 5, 6, 7, 8], 
      [list: 12, 11, 10, 9]], 
    initial-below-seams-2)
    is 
  [list:
    seam(12 + 5 + 3 + 1, [list: 0, 0, 1, 0]),
    seam(11 + 5 + 3 + 1, [list: 1, 0, 1, 0]),
    seam(10 + 6 + 3 + 1, [list: 2, 1, 1, 0]), 
    seam(9 + 7 + 3 + 1, [list: 3, 2, 1, 0])]
end

fun build-new-seams(next-up-row :: List<Number>, curr-idx :: Number, 
    below-seams :: List<Seam>) -> List<Seam>:
  doc: ```builds the best possible seams down from each nrg value in the given 
       list of nrgies using information from the below-seams. 
       Incorporates both lowest nrg and left-most decision making as well. ```
  cases (List) next-up-row:
    | empty => empty 
    | link(first-nrg, rest-nrgies) =>
      link(
        update-nrg-to-seam(first-nrg, curr-idx, below-seams),
        build-new-seams(rest-nrgies, curr-idx + 1, below-seams))
  end
where:
  freshly-initialized-below-seams = 
    [list: 
      seam(3, [list: 0]), 
      seam(5, [list: 1]),
      seam(2, [list: 2]), 
      seam(6, [list: 3])]
  build-new-seams([list: 1, 2, 3, 4], 0, freshly-initialized-below-seams)
    is 
  [list: 
    seam(1 + 3, [list: 0, 0]),
    seam(2 + 2, [list: 1, 2]), 
    seam(3 + 2, [list: 2, 2]), 
    seam(4 + 2, [list: 3, 2])]
  below-seams-with-developed-seams = 
    [list: 
      seam(4, [list: 0, 1, 2, 3]), 
      seam(3, [list: 1, 2, 3, 4]),
      seam(2, [list: 2, 2, 5, 6]), 
      seam(2, [list: 3, 2, 1, 1])]
  build-new-seams([list: 1, 2, 3, 4], 0, below-seams-with-developed-seams)
    is 
  [list: 
    seam(1 + 3, [list: 0, 1, 2, 3, 4]),
    seam(2 + 2, [list: 1, 2, 2, 5, 6]), 
    seam(3 + 2, [list: 2, 2, 2, 5, 6]), 
    seam(4 + 2, [list: 3, 2, 2, 5, 6])]
end
        
check "update-nrg-to-seam, left edge scenarios":
  l-edge-choose-right-below-seams = 
    [list: 
      seam(4, [list: 0]), 
      seam(2, [list: 1]), 
      seam(5, [list: 2]), 
      seam(6, [list: 3])]
  l-edge-choose-below-below-seams = 
    [list:  
      seam(2, [list: 1]), 
      seam(4, [list: 0]), 
      seam(5, [list: 2]), 
      seam(6, [list: 3])]
  update-nrg-to-seam(3, 0, l-edge-choose-right-below-seams)
    is seam(3 + 2, [list: 0, 1])
  update-nrg-to-seam(3, 0, l-edge-choose-below-below-seams)
    is seam(3 + 2, [list: 0, 1])
end

check "update-nrg-to-seam, right edge scenarios":
  r-edge-choose-below-below-seams = 
    [list:
      seam(0, [list: 0]), 
      seam(5, [list: 1]),
      seam(3, [list: 2]), 
      seam(2, [list: 3])]
  r-edge-choose-d-left-below-seams = 
    [list: 
      seam(0, [list: 0]), 
      seam(5, [list: 1]),
      seam(2, [list: 2]), 
      seam(3, [list: 3])]
  update-nrg-to-seam(4, 3, r-edge-choose-below-below-seams)
    is seam(4 + 2, [list: 3, 3])
  update-nrg-to-seam(4, 3, r-edge-choose-d-left-below-seams)
    is seam(4 + 2, [list: 3, 2])
end

check "update-nrg-to-seam, middle pixels scenarios":
  middle-choose-below-below-seams = 
    [list: 
      seam(3, [list: 0]), 
      seam(5, [list: 1]),
      seam(2, [list: 2]), 
      seam(6, [list: 3])]
  middle-choose-d-right-below-seams = 
    [list: 
      seam(0, [list: 0]), 
      seam(3, [list: 1]),
      seam(4, [list: 2]), 
      seam(1, [list: 3])]
  middle-choose-d-left-below-seams = 
    [list: 
      seam(2, [list: 0]), 
      seam(1, [list: 1]),
      seam(5, [list: 2]), 
      seam(3, [list: 3])]
  skinny-img-below-seams = 
    [list: 
      seam(4, [list: 0])]
  update-nrg-to-seam(3, 2, middle-choose-below-below-seams)
    is seam(3 + 2, [list: 2, 2])
  update-nrg-to-seam(3, 2, middle-choose-d-right-below-seams)
    is seam(3 + 1, [list: 2, 3])
  update-nrg-to-seam(3, 2, middle-choose-d-left-below-seams)
    is seam(3 + 1, [list: 2, 1])
  update-nrg-to-seam(1, 0, skinny-img-below-seams)
    is seam(1 + 4, [list: 0, 0])
end

check ```check that update-nrg-to-seam deals with tied nrgies by choosing to work with the 
      left-most seam option```:
  below-left-equal-below-seams = 
    [list: 
      seam(1, [list: 0]), 
      seam(1, [list: 1]),
      seam(5, [list: 2]), 
      seam(3, [list: 3])]
  below-left-equal-in-middle-below-seams = 
    [list:
      seam(4, [list: 0]), 
      seam(2, [list: 1]),
      seam(2, [list: 2]), 
      seam(3, [list: 3])]
  right-equal-below-seams = 
    [list:
      seam(4, [list: 0]), 
      seam(3, [list: 1]),
      seam(2, [list: 2]), 
      seam(2, [list: 3])]
  update-nrg-to-seam(1, 0, below-left-equal-below-seams)
    is seam(1 + 1, [list: 0, 0])
  update-nrg-to-seam(2, 1, below-left-equal-in-middle-below-seams)
    is seam(2 + 2, [list: 1, 1])
  update-nrg-to-seam(3, 2, below-left-equal-in-middle-below-seams)
    is seam(3 + 2, [list: 2, 1])
  update-nrg-to-seam(4, 3, right-equal-below-seams)
    is seam(4 + 2, [list: 3, 2])
end

check "update-nrg-to-seam tests where the seams lists are filled out":
  filled-out-below-seams =  
    [list: 
      seam(4, [list: 0, 1, 2, 3]), 
      seam(3, [list: 1, 2, 3, 4]),
      seam(2, [list: 2, 2, 5, 6]), 
      seam(2, [list: 3, 2, 1, 1])]
  update-nrg-to-seam(1, 0, filled-out-below-seams)
    is seam(1 + 3, [list: 0, 1, 2, 3, 4])
  update-nrg-to-seam(3, 2, filled-out-below-seams)
    is seam(3 + 2, [list: 2, 2, 2, 5, 6])
end

fun update-nrg-to-seam(nrg :: Number, curr-idx :: Number, 
below-seams :: List<Seam>) -> Seam:
  doc: ```takes in an nrg value, its index in the image (how far along the width it is)
       and a below-seams list, and outputs a leftmost lowest nrg seam that 
       incorporates the given nrg value```
  diag-left = curr-idx - 1
  diag-right = curr-idx + 1
  below-seam = below-seams.get(curr-idx) # we are guaranteed 
  # this value and don't have to check because it has been initialized already
  below-nrg = below-seam.energy
  below-path = below-seam.path
  cases (Option) option-get(diag-left, below-seams):
    | none => 
      cases (Option) option-get(diag-right, below-seams):
        | none => # case where the image is just 1 pixel wide
          # (no diagonal left or right entries possible) 
          seam(below-nrg + nrg, link(curr-idx, below-path))
        | some(right-seam) => # case where the pixel is on the left edge of the img
          # (only has a diagonal right and a pixel below it)
          right-nrg = right-seam.energy
          ask:   
            | below-nrg <= right-nrg then: # if below seam is lower nrg than the right seam, 
              # choose the below seam. # if both the below and the right seam nrgies are equal,
              # still choose the below seam because that is the leftmost choice:
              seam(below-nrg + nrg, link(curr-idx, below-path))
            | below-nrg > right-nrg then: 
              seam(right-nrg + nrg, link(curr-idx, right-seam.path))
          end
      end
      | some(left-seam) => 
        left-nrg = left-seam.energy
      cases (Option) option-get(diag-right, below-seams):
        | none => # case where the pixel is on the right edge of the img
          # (only has a diagonal left and a pixel below it)
          ask:
            | left-nrg <= below-nrg then: # if below seam is lower nrg than the left seam,
              # choose the left seam. # if both have equal nrgies, still choose the left seam 
              # bc that is the leftmost choice.
              seam(left-nrg + nrg, link(curr-idx, left-seam.path))
            | left-nrg > below-nrg then:
              seam(below-nrg + nrg, link(curr-idx, below-path))
          end
        | some(right-seam) => # case where the pxl has both diagonal left/right and 
          # below neighbors:
          right-nrg = right-seam.energy
          if (left-nrg <= below-nrg) and (left-nrg <= right-nrg):
            seam(left-nrg + nrg, link(curr-idx, left-seam.path))
          else: 
            if below-nrg <= right-nrg:
              seam(below-nrg + nrg, link(curr-idx, below-path))
            else:
              seam(right-nrg + nrg, link(curr-idx, right-seam.path))
            end
          end
      end
  end
end

fun initialize(nrg-row :: List<Number>, curr-idx :: Number) -> List<Seam>:
  doc: ```takes in a row of energies, a starting idx, and outputs a list of seams```
  cases (List) nrg-row:
    | empty => empty
    | link(first-nrg, rest-nrgies) => 
      link(seam(first-nrg, [list: curr-idx]), initialize(rest-nrgies, curr-idx + 1))
  end
where:
  initialize([list: 3, 1, 2, 5], 0)
    is [list: seam(3, [list: 0]), seam(1, [list: 1]), seam(2, [list: 2]), seam(5, [list: 3])]
end