
(defun
      wczytajIloscLinii (/)
     	(setq ileLinii (getint))
  	(setq ileLinii (- ileLinii 1))
)

(defun
       rysujLinie (A B/)
  	(command "_line" A B "")
)

(defun
       sprawdzKolizje (A B C K)
  	(setq Y1 1)
  	(if (and (> (nth 1 C) (nth 1 A))(> (nth 1 A) (nth 1 B)) )
		(setq Y1 0)
	  )
	  (if (and (< (nth 1 C) (nth 1 A))(< (nth 1 A) (nth 1 B)) )
			(setq Y1 0)
		  )
  	
  	(if (> Y1 0)
	  (progn
	   	(if (< (nth 0 A) (nth 0 B))
	  	  (setq K 1)
	  	  (setq K 0)
	        )
	  )
	  (setq K 0)  
	)		
)

(setq iloscLinii (wczytajIloscLinii))
(setq A (getpoint))
(setq B (getpoint))


;(setq C1Y (+ (nth 0 A) (nth 0 B)))
;(setq C1Y (/ C1Y 2))
;(setq C1X (+ (nth 1 A) (nth 1 B)))
;(setq C1X (/ C1X 2))
;(setq C1 (list C1Y C1X 0))
(setq C1 A)

(command "_line" A B "")
(setq i 0)
(setq j 2)
(while (< i iloscLinii)
  		(setq C A)
    		(setq A B)
  		(setq B (getpoint))
  		(setq K (sprawdzKolizje A B C K))
  		(if (= K 1)
		    (rysujLinie A B)
		    (progn
		      (setq i (- i 1))
		      (setq j (- j 1))
		      (setq B A)
		      (setq A C)
		    )
		)
		(setq i (+ i 1))
  		(setq j (+ j 1))
 ; druga czesc zadania
  (if (and (= j 3)(= K 1))       ;jesli dorysowano trzeci wierzcholek...
    (progn
	(setq j 1)
      
      	(setq B1Y (+ (nth 0 C) (nth 0 B)))
        (setq B1Y (+ B1Y (nth 0 A)))
      	(setq B1Y (/ B1Y 3))
      
      	(setq B1X (+ (nth 1 C) (nth 1 B)))
        (setq B1X (+ B1X (nth 1 A)))
      	(setq B1X (/ B1X 3))
      
      	(setq B1 (list B1Y B1X 0))
      	(command "_line" C1 B1 "")
      	(setq C1 B1)
      	
      )
  )
)

;(setq B1Y (+ (nth 0 B) (nth 0 A)))
;(setq B1Y (/ B1Y 2))
;(setq B1X (+ (nth 1 B) (nth 1 A)))
;(setq B1X (/ B1X 2))
;(setq B1 (list B1Y B1X 0))
;(command "_line" C1 B1 "")
(command "_line" C1 B "")