(vl-load-com)
(setq aplikacja (vlax-get-acad-object))
(setq aktywny (vla-get-activedocument aplikacja))
(vlax-dump-object aplikacja T)
(vlax-dump-object aktywny T)
(setq blocks (vla-get-blocks aktywny))
(setq mspace (vla-get-modelspace aktywny))

(setq blocksL nil)
(setq lista_ref nil)

(vlax-for iblock blocks
  (progn
  	(setq blocksL (append blocksL (List iblock)))
    	(setq l_ref nil)
  	(vlax-for item mspace
	  (if (= (vlax-get-property item 'ObjectName) "AcDbBlockReference")
	    (if (= (vla-get-name item) (vla-get-name iblock))
	      (setq l_ref (append l_ref (list item)))
	    )
	  )
  	)
    	(setq lista_ref (append lista_ref (list l_ref)))
  )
)
