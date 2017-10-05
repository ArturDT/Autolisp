(vl-load-com)
(setq aplikacja (vlax-get-acad-object))
(setq aktywny (vla-get-activedocument aplikacja))
(vlax-dump-object aplikacja T)
(vlax-dump-object aktywny T)
(setq blocks (vla-get-blocks aktywny))
(setq mspace (vla-get-modelspace aktywny))

(setq lista_blokow nil)
(setq lista_komp nil)
(setq lista_nazw nil)

(vlax-for iblock blocks
  (progn
  	(setq lista_blokow (append lista_blokow (List iblock)))
  	(setq lista_temp nil)
  	(vlax-for item iblock
	  (setq lista_temp (append lista_temp (list item)))
	)
    	(if  (and (and (/= (vla-get-name iblock) "*Model_Space") (/= (vla-get-name iblock) "*Paper_Space") (/= (vla-get-name iblock) "*Paper_Space0")))
		 ( progn
		   	(setq lista_nazw (append lista_nazw (list (vla-get-name iblock))))
	  		(setq lista_komp (append lista_komp (list lista_temp)))
		 )
	)
   )
);lista_komp zawiera w tym momencie zbior wszystkich komponentow kadzdego z blokow, nalezy teraz przeanalizowac te bloki, zeby wpisac je na lista_hierarchia pod odpowiednim indeksem

(setq lista_hierarchia nil)
(setq lista_hier_nazw nil)
(setq lista_temp nil)
(setq lista_temp_nazw nil)
;(setq test (nth 1 (nth 2 lista_komp)) ) ;taki zapis pozwala dostac sie do poszczegolnych podelementow z lista_komp
;ta petla odpowiada za znalezienie blokow poziomu 0 (indeks 0))
(setq ind 0)
(setq wsk (length lista_komp));wsk wskazuje ile elementow pozostalo do przydzielenia do listy z hierarchia
(foreach item lista_komp
  	(setq test 0)
	(foreach poditem item
		(if (= (vlax-get-property poditem 'ObjectName) "AcDbBlockReference")
		 (setq test 1)
		)
	)
 	(if (= test 0)
	  (progn
	  	(setq lista_temp (append lista_temp (list item)))
	  	(setq lista_temp_nazw (append lista_temp_nazw (list (nth ind lista_nazw))))
	    	(setq wsk (- wsk 1))
	   )
	)
(setq ind (+ ind 1))
)
(setq lista_hierarchia (append lista_hierarchia (list lista_temp)))
(setq lista_hier_nazw (append lista_hier_nazw (list lista_temp_nazw)))
;w lista_hierarchia znajduja sie juz bloki pierwszego poziomu (lista_hier_nazw zawiera nazwy tych blokow)
;teraz poziomy kolejne w jednej petli:
(setq aktualny_ind 0) ;indeks, pod ktorym znajduja sie obiekty z poprzedniego poziomu
(setq wsk_znaleziono 0 ) ;jesli 1 to znaleziono - tzn znaleziono w blokach podrzednych blok wchodzacy w sklad badanego bloku...
(setq wsk_nieznaleziono 0)
(setq wsk_test 0)
(while (and (> wsk 0) (< aktualny_ind 20)) ;petla wykonuje sie dopoki wszystkie elementy nie zostana przypisane do listy hierarchia
	(setq lista_temp nil)
  	(setq lista_temp_nazw nil)
  	(setq ind 0)
  	(foreach item lista_komp
		(foreach poditem item	  	
			(if (= (vlax-get-property poditem 'ObjectName) "AcDbBlockReference")
			  (progn
			    (foreach item2 (nth aktualny_ind lista_hier_nazw)
				   (if (= (vla-get-name poditem) item2)
				       (setq wsk_znaleziono 1)
				   )
			    )
			    (setq ind2 aktualny_ind)
			    (setq wsk_test 0)
			    (while (> ind2 -1)
			       (foreach item3 (nth ind2 lista_hier_nazw)
				   (if (= (vla-get-name poditem) item3)
				       (setq wsk_test 1)
				   )
			       )
			       (setq ind2 (- ind2 1))
			    )
			    (if (= wsk_test 0)
			       (setq wsk_nieznaleziono 1)
			    )
			  )
			)
		)
	  	(if (and (= wsk_znaleziono 1)(= wsk_nieznaleziono 0))
	  	(progn
	    		(setq lista_temp (append lista_temp (list item)))
	    		(setq lista_temp_nazw (append lista_temp_nazw (list (nth ind lista_nazw))))
	    		(setq wsk (- wsk 1))
	  	)
		)
        	(setq wsk_znaleziono 0 )
	  	(setq wsk_nieznaleziono 0)
	  	(setq ind (+ ind 1))
	)
  	(setq lista_hierarchia (append lista_hierarchia (list lista_temp)))
	(setq lista_hier_nazw (append lista_hier_nazw (list lista_temp_nazw)))
  	(setq aktualny_ind (+ aktualny_ind 1))
;(print aktualny_ind)
)