(vl-load-com)
(setq aplikacja (vlax-get-acad-object))
(vlax-dump-object aplikacja T)
(setq aktywny (vla-get-activedocument aplikacja))
(setq mspace (vla-get-modelspace aktywny))
(setq item (vla-item mspace 0)) ;pobranie obiektu nr 0 z mspace

(setq mspace1 (vlax-for item mspace
		(setq mspace1 (append mspace1 (list item)))
	      )
) ;skopiowanie elementow z mspace do mspace1

(vla-addline mspace (getpoint)(getpoint)) ;dodanie linii do mspace z konwersja punktu na wariant
;wariant to tablica widziana w lispie... wiec punkty z listy trzeba przepisac do tablicy za pomoca odpowiednio skonstruowanej funkcji

