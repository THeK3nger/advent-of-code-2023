# Advent of Code 2023
# Day 03
# https://adventofcode.com/2023/day/1

(def real-input (slurp "input.txt"))

# Part 1

(def test-input ```
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
```)

(def peg ~{:main (split "\n" (group :line))
           :line (some (+ (number :d) 1))})

(defn solve01 [input]
  (sum (seq [line :in (peg/match peg input)] (+ (* 10 (first line)) (last line)))))

(pp (solve01 real-input))

# Part 2

(def test-input2 ```
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
```)

(def peg2 ~{:main (split "\n" (group :line))
            :line (some (+ :number 1))
            :number (+ (number :d)
                       (if (+
                             (/ "one" 1)
                             (/ "two" 2)
                             (/ "three" 3)
                             (/ "four" 4)
                             (/ "five" 5)
                             (/ "six" 6)
                             (/ "seven" 7)
                             (/ "eight" 8)
                             (/ "nine" 9)) 1))})

(defn solve02 [input]
  (sum (seq [line :in (peg/match peg2 input)] (+ (* 10 (first line)) (last line)))))

(pp (solve02 real-input))
