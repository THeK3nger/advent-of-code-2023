# This macro comes from the tutorial I am following at
# https://www.youtube.com/watch?v=yLsLIofgIs8
(defmacro fold-loop [init f dsl & body]
  (with-syms [$result $f]
    ~(let [,$f ,f]
       (var ,$result ,init)
       (loop ,dsl
         (set ,$result (,$f ,$result (do ,;body))))
       ,$result)))
