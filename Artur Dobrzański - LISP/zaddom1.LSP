
(print "program rysuj¹cy")
;(command "_line" (list 0 0) (list 0 100) (list 100 100) (list 100 100)"_c")

(setq x1 0)
(setq y1 0)
(setq z1 0)
(setq r1  20)
(print "podaj ilosc kolumn:")
(setq kolumny (getint))
(print "podaj ilosc wierszy:")
(setq wiersze (getint))
(print "podaj odstep:")
(setq odstep(getdist))

(if (> odstep r1)
  (progn
(repeat kolumny
  (progn
  (setq ii 0)
  (while (< ii wiersze) 
  (progn
(setq ii (+ 1 ii))
(command "_circle" (list x1 y1 z1) r1)
(command "_extrude" (entlast) "" r1)
(setq x1 (+ odstep x1))
       )	)
  (setq y1 (+ odstep y1))
  (setq x1 0)
  ))
)
  (print "odstep musi byc wiekszy niz promien!") 
)
