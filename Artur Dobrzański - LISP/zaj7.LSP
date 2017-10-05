(vl-load-com)
(setq aplikacja (vlax-get-acad-object))
(vlax-dump-object aplikacja T)
(setq aktywny (vla-get-activedocument aplikacja))
(setq mspace (vla-get-modelspace aktywny))


(setq selset (ssget "x"))
(setq listaobj nil)
(setq listaent nil)
(setq licznik 0)
(setq ind_max 0)
(setq r_max 0)
(repeat (sslength selset)
  (setq obj (vlax-ename->vla-object (ssname selset licznik) ))
  (setq listaent (append listaent (list(ssname selset licznik))))
  (setq listaobj (append listaobj (list obj)))
  (if (< r_max (vlax-get-property (nth licznik listaobj) 'Radius) )
	(progn
	  (setq ind_max licznik)
	  (setq r_max (vlax-get-property (nth licznik listaobj) 'Radius))
	  )
  )
  (setq licznik (1+ licznik))
)
(ssdel (nth ind_max listaent) selset)
(sssetfirst nil selset)


