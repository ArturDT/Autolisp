(loadall)
(loadConfig)
(progn
  (restart)
  (print "Rozpoczeto nowa gre")
  (setq iii 1)
  (while (= iii 1)
    (progn
      (readKey)
      (if (= wcisnietoX 1)
	(progn
	  (ruchPrawa)
	  (setq licznikX (+ licznikX 1))
	)
       (progn
         (if (= wcisnietoZ 1)
	  (progn
	    (ruchLewa)
	    (setq licznikZ (+ licznikZ 1))
	  )
	 )
       )
      )
      (if (= licznikX (* iloscRuchow 2))
	(zerujX)
      )
      (if (= licznikZ (* iloscRuchow 2))
	(zerujZ)
      )
    )
    (setq indRuch 0)
    (while (< indRuch 40)
      (ruszKulka)
      (setq indRuch (+ indRuch 1))
    )
  )
  (koniecGry)
)