(vl-load-com)
(setq aplikacja (vlax-get-acad-object))
(setq aktywny (vla-get-activedocument aplikacja))
(vlax-dump-object aplikacja T)
(vlax-dump-object aktywny T)
(setq blocks (vla-get-blocks aktywny))
(setq mspace (vla-get-modelspace aktywny))

(setq lista_blokow nil)
(setq lista_komp nil)

(vlax-for iblock blocks
  (progn
  	(setq lista_blokow (append lista_blokow (List iblock)))
  	(setq lista_temp nil)
        (setq lista_temp (append lista_temp (list (vla-get-name iblock))))
  	(vlax-for item iblock
	  (setq lista_temp (append lista_temp (list item)))
	)
  	(setq lista_komp (append lista_komp (list lista_temp)))
   )
)
