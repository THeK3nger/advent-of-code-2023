# Advent of Code 2023
# Day 03
# https://adventofcode.com/2023/day/3

(use ../util)

(def test-input ```
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
```)

(def real-input (slurp "input.txt"))

(def peg ~{:main (some (+ :number :blank :symbol))
           :number (group (* (constant :number) (line) (column) (number :d+) (/ (column) ,dec)))
           :blank (set ".\n")
           :symbol (group (* (constant :symbol) (line) (column) '1))})

# Returns a sequence of points that are neighbors of the given point range
# Note that a number occupy multiple cells on a line, so the neighbors are
# all the points in the rectangular box around the number.
(defn neighbors [{:line line :scol scol :ecol ecol}]
  (seq [l :range-to [(dec line) (inc line)]
        c :range-to [(dec scol) (inc ecol)]
        :unless (and (= line l) (>= c scol) (<= c ecol))] [l c]))

# Given a reference to a number (that is a number + its line and the column range)
# we check if any of its neighbors is a symbol (a symbol is a single character)
(defn next-to-symbol? [number lookup]
  (fold-loop false |(or $0 $1) [point :in (neighbors number)
                                :let [neighbor (in lookup point)]
                                :when neighbor]
             (has-key? neighbor :symbol)))

# This just assemble the lookup table and the arrays of numbers and symbols.
(defn parse-input [input]
  (def lookup @{})
  (def numbers @[])
  (def symbols @[])
  (loop [element :in (peg/match peg input)]
    (match element
      [:number line scol number ecol]
      (do
        (def number @{:line line :scol scol :ecol ecol :number number})
        (array/push numbers number)
        (loop [col :range-to [scol ecol]] (put lookup [line col] number)))
      [:symbol line col symbol]
      (do
        (def symbol @{:symbol symbol :line line :col col})
        (array/push symbols symbol)
        (put lookup [line col] symbol))))
  [lookup numbers symbols])

(defn solve1 [input]
  (def [lookup numbers symbols] (parse-input input))
  (sum (seq [number :in numbers
             :when (next-to-symbol? number lookup)] (in number :number))))

(pp (solve1 real-input))

# Part 2

# This performs a similar task as next-to-symbol? but instead of checking if
# a number is next to a symbol, returns all the numbers that are next to the
# symbol. In short, it is the "reverse".
(defn adjacent-numbers [{:line line :col col} lookup]
  (distinct (seq [point :in (neighbors @{:line line :scol col :ecol col})
                  :let [neighbor (in lookup point)]
                  :when neighbor]
              neighbor)))

(defn solve2 [input]
  (def [lookup numbers symbols] (parse-input input))
  (sum (seq [symbol :in symbols
             :when (= (in symbol :symbol) "*")
             :let [adjacent-numbers (adjacent-numbers symbol lookup)]
             :when (= (length adjacent-numbers) 2)]
         (product (map |(in $ :number) adjacent-numbers)))))

(pp (solve2 real-input))
