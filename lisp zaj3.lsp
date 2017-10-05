(vl-load-com)
(setq aplikacja (vlax-get-acad-object))
(vlax-dump-object aplikacja T)
(setq sciezka (vlax-get-property aplikacja "path"))
(setq sciezka (vla-get-path aplikacja))
(setq aktywny (vla-get-activedocument aplikacja))
(print sciezka)
(print aktywny)
(vlax-dump-object aktywny T)



(setq docsC (vla-get-document aplikacja)) ;
(setq dokument (vla-item docsC 0)) ; w przypadku kolekcji najpierw podajemy kolekcje potem indeks interesuj¹cy nas, odwrotnie ni¿ w przypadku listy

(repeat (vla-get-count docS)
	(setq docsL (append docsL (list (vla-item docsC licz))))
	(setq licz (1+ licz))
);kazdy element z kolekcji zapisuje do listy... 

(vlax-for idoc docsC
	(setq docsLi (append docsLi (list idoc)))
);jw

;program z zajec:
(vl-load-com)
(setq aplikacja (vlax-get-acad-object))
(vlax-dump-object aplikacja T)

(setq aktywny (vla-get-activedocument aplikacja))

(setq docsC (vla-get-documents aplikacja))

(setq dokument (vla-item docsC 0))

(setq licz 0)
(repeat (vla-get-count docsC)
  (setq docsL (append docsL (list (vla-item docsC licz))))
  (setq licz (1+ licz))
  )

(vlax-for idoc docsC
   (setq docsLi (append docsLi (list idoc)))
  )

(vlax-dump-object dokument T)

(setq layerC (vla-get-layers dokument))

(vlax-for ilay layerC
   (setq layerL (append layerL (list ilay)))
  )

(setq laymod (nth 17 layerL))
(setq name (vla-get-name laymod))
(vla-put-name laymod "dach_jolki")

