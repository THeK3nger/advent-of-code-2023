# Advent of Code 2023
# Day 4
# https://adventofcode.com/2023/day/4

(def test-input ```
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
```)

(def real-input (slurp "input.txt"))

(def peg ~{:main (split "\n" :card)
           :card (group (* "Card" :s+ (number :d+) ":" :numbers "|" :numbers))
           :numbers (group (* :s* (some (* (number :d+) :s*))))})

(pp (peg/match peg test-input))

# This is a small function to increase the value of a key in a map.
# Nothing special, but it saves a bit of typing.
(defn incr [t k &opt by]
  (default by 1)
  (put t k (+ by (in t k 0))))

# The scoring function. It is not really necessary to make a function for this,
# but it makes the code a bit more readable.
(defn scoring [n] (if (<= n 0) 0 (math/exp2 (dec n))))

# This function returns the number of matches between the winning numbers and
# the card numbers.
(defn matching [[id win numbers]]
  (length (seq [n :in numbers :when (has-value? win n)])))

(defn solve1 [input]
  (let [cards (peg/match peg input)]
    (sum (map |(scoring (matching $)) cards))))

(pp (solve1 real-input))

# --- Part 2 ---
# 
# Part two uses all the content from part 1 but id does this weird loop where
# the number of cards increases depending on the number of matches of the
# previous cards. In this case I followed Ian Henry solution more closely 
# becase I still had some trouble with Janet's syntax.

(defn solve2 [input]
  (def copies @{})
  (sum (seq [[id win numbers] :in (peg/match peg input)]
         (def m (matching [id win numbers]))
         (def instances-of-this-card (inc (in copies id 0)))
         (for offset 0 m
           (incr copies (+ id offset 1) instances-of-this-card))
         instances-of-this-card)))

(pp (solve2 real-input))
