;1. napisaæ funkcjê, która bêdzie pobiera³a punkty do momentu,
;a¿ u¿ytkownik kliknie trzeci¹ æwiartkê.
;trzecia æwiartka x < 0 i y < 0
;2. ZnaleŸæ punkty a) max lewo b) max prawo c) max góra d) max dó³ 
;3. Po³¹czyæ je lini¹

(setq listaPkt nil)
(setq iloscPkt 0)
(setq i 0)
(while (< i 1)
  		(setq B (getpoint))
  		(setq listaPkt (append listaPkt B))
  		(setq iloscPkt (+ iloscPkt 1))
  
	(if (< (nth 0 B) 0)
	  (if (< (nth 1 B) 0)
	    (setq i (+ i 1))))
)
(setq iloscPkt (* iloscPkt 3))
(setq i 0)

(setq maxGora 0)
(setq maxDol  0)
(setq maxLewo 1)
(setq maxPrawo 1)

(while (< i iloscPkt)
  (setq j (+ i 1))
  
	(if (> (nth i listaPkt) (nth maxGora listaPkt))
	  (setq maxGora i)
	  )
  	(if (< (nth i listaPkt) (nth maxDol listaPkt))
	  (setq maxDol i)
	  )
  	(if (< (nth j listaPkt) (nth maxLewo listaPkt))
	  (setq maxLewo j)
	  )
  	(if (> (nth j listaPkt) (nth maxPrawo listaPkt))
	  (setq maxPrawo j)
	  )

	(setq i (+ i 3))
  )
  (command "_line"
	   (list (nth maxGora listaPkt)(nth (+ maxGora 1) listaPkt))
	   (list (nth (- maxLewo 1) listaPkt)(nth maxLewo listaPkt))
	   (list (nth maxDol listaPkt)(nth (+ maxDol 1) listaPkt))
	   (list (nth (- maxPrawo 1) listaPkt)(nth maxPrawo listaPkt))
	   (list (nth maxGora listaPkt)(nth (+ maxGora 1) listaPkt))
	    "")  