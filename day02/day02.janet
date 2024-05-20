# Advent of Code 2023
# Day 02
# https://adventofcode.com/2023/day/2

(def real-input (slurp "input.txt"))

(def test-input ```
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
```)

(def peg ~{:main (split "\n" :game)
           :game (/ (* "Game " (number :d+) ": " :rounds) ,|{:id $0 :rounds $&})
           :rounds (split "; " (/ :round ,|(struct ;(reverse $&))))
           :round (split ", " :cube)
           :cube (* (number :d+) " " :color)
           :color (/ ':w+ ,keyword)})

(defn rgb [struct]
  [(in struct :red 0) (in struct :green 0) (in struct :blue 0)])

(defn summarize-rounds [rounds]
  (map max ;(map rgb rounds)))

(defn solve01 [input]
  (sum (seq [{:id id :rounds rounds} :in (peg/match peg input)
             :let [summary (summarize-rounds rounds)]
             :when (all <= summary [12 13 14])] id)))

(pp (solve01 real-input))

(defn solve02 [input]
  (sum (seq [{:id id :rounds rounds} :in (peg/match peg input)
             :let [summary (summarize-rounds rounds)]] (* ;summary))))

(pp (solve02 real-input))
