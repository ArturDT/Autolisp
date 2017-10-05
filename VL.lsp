(vl-load-com)
(setq aplikacja (vlax-get-acad-object))
(vlax-dump-object aplikacja T)
(setq sciezka (vlax-get-property aplikacja "path"))
(setq sciezka (vla-get-path aplikacja))
(setq aktywny (vla-get-activedocument aplikacja))

(vlax-dump-object aktywny T)
