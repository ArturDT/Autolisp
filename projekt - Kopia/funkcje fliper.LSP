;##################################################################
;funkcja odpowiadajaca za zaladowanie obiektow do programu 
(defun loadall () 
  (vl-load-com)
  (setq *acadobj* (vlax-get-acad-object))
  (setq *ActiveDocument* (vla-get-activedocument *acadobj*))
  (setq *ModelSpace* (vla-get-modelspace *ActiveDocument*))
  (setq blocks (vla-get-blocks *ActiveDocument*))
  (if (not (member "geom3d.arx" (arx)))
    (arxload "geom3d")
  )
  (loadSset)
  (loadItems)
)
;end loadall
;##################################################################

;##################################################################
;funkcja wczytujaca ssety wykorzystywane w programie
(defun loadSset ()
  (setq dzwigniaPrawa (ssget "_C" '(-3000 -3000) '(3000 3000) (list (cons 8 "dzwigniaPrawa"))))
  (setq dzwigniaLewa (ssget "_C" '(-3000 -3000) '(3000 3000) (list (cons 8 "dzwigniaLewa"))))
  (setq obwDzwigniL (ssget "_C" '(-3000 -3000) '(3000 3000) (list (cons 8 "obwLewejDzwigni"))))
  (setq obwDzwigniP (ssget "_C" '(-3000 -3000) '(3000 3000) (list (cons 8 "obwPrawejDzwigni"))))
)
;end loadSset
;##################################################################

;##################################################################
;funkcja ladujaca obiekty wykorzystywane w programie
(defun loadItems ()
  (setq kulka nil)
  (setq obwBokow nil)
  (setq punkty10 nil)
  (vlax-for item *ModelSpace*
    (if (= (vlax-get-property item 'Layer) "kulka")
      (setq kulka item)
    )
    (if (= (vlax-get-property item 'Layer) "boki")
      (setq boki item)
    )
    (if (= (vlax-get-property item 'Layer) "obwBokow")
      (setq obwBokow (append obwBokow (List item)))
    )
    (if (= (vlax-get-property item 'Layer) "obwKulki")
      (setq obwKulki item)
    )
    (if (= (vlax-get-property item 'Layer) "obwLewejDzwigni")
      (setq obwLewejDzwigni item)
    )
    (if (= (vlax-get-property item 'Layer) "obwPrawejDzwigni")
      (setq obwPrawejDzwigni item)
    )
    (if (= (vlax-get-property item 'Layer) "deathLine")
      (setq deathLine item)
    )
    (if (= (vlax-get-property item 'Layer) "punkty10")
      (setq punkty10 (append punkty10 (List item)))
    )
  )
)
;end loadItems
;##################################################################

;##################################################################
;funkcja ustawiajaca flagi oraz parametry poczatkowe gry
(defun loadConfig ()
  ;config
  (setq kat 5)
  (setq iloscRuchow 12)  ;kat*iloscRuchow = kat przesuniecia (3*10 = 30)
  (setq szybkoscPoczatkowaKulki 1)
  (setq sumaPkt 0)
  
  ;flagi:
  (setq wcisnietoX 0)
  (setq wcisnietoZ 0)
  (setq licznikX 0)
  (setq licznikZ 0)
  (setq szybkoscKulkiX 0)
  (setq szybkoscKulkiY 0)
)
;end loadConfig
;##################################################################

;##################################################################
;funkcja zczytujaca klawisze:
(defun readKey ()
(setq tempList (grread T 5 2)) ;to to true - pierwszy argument musi byc not nill aby obsluzyc myszke
    ;wcisnieto s (start):
    (if (and (equal (car tempList) 2) (vl-position (cadr tempList) '(115)))
      (restart)
    )
    ;wcisnieto x (prawa dzwignia):
    (if (and (equal (car tempList) 2) (vl-position (cadr tempList) '(120)))
      (progn
	(print "wcisnieto x - ruch prawa dzwignia")
	(setq wcisnietoX 1)
      )
    )
    ;wcisnieto z (lewa dzwignia):
    (if (and (equal (car tempList) 2) (vl-position (cadr tempList) '(122)))
      (progn
	(print "wcisnieto z - ruch lewa dzwignia")
	(setq wcisnietoZ 1)
      )
    )
    ;wcisnieto q (koniec):
    (if (and (equal (car tempList) 2) (vl-position (cadr tempList) '(113)))
      (progn
	(print "wcisnieto q program konczy dzialanie")
 	(setq iii 0)
      )
    )
    ;wcisnieto a (ruszenie stolem)
    (if (and (equal (car tempList) 2) (vl-position (cadr tempList) '(97)))
      (progn
	(print "wstrzasnieto stolem, kulka zmienia nieco trajektorie")
 	(wstrzasStolu)
      )
    )
)
;end readKey
;##################################################################

;##################################################################
;funkcja zmieniajaca kat ruchu pilki
(defun wstrzasStolu ()
  (if (and (< szybkoscKulkiY -0.2) (< szybkoscKulkiX -0.2) (< szybkoscKulkiY 0) (< szybkoscKulkiX 0))
     (progn
       (setq szybkoscKulkiX (+ szybkoscKulkiX 0.2))
       (setq szybkoscKulkiY (- szybkoscKulkiY 0.2))
     )
  )
  (if (and (> szybkoscKulkiY 0.2) (> szybkoscKulkiX 0.2) (> szybkoscKulkiY 0) (> szybkoscKulkiX 0))
     (progn
       (setq szybkoscKulkiX (+ szybkoscKulkiX 0.2))
       (setq szybkoscKulkiY (- szybkoscKulkiY 0.2))
     )
  )
  (if (and (> szybkoscKulkiY 0.2) (< szybkoscKulkiX -0.2) (> szybkoscKulkiY 0) (< szybkoscKulkiX 0))
     (progn
       (setq szybkoscKulkiX (+ szybkoscKulkiX 0.2))
       (setq szybkoscKulkiY (+ szybkoscKulkiY 0.2))
     )
  )
  (if (and (< szybkoscKulkiY -0.2) (> szybkoscKulkiX 0.2) (< szybkoscKulkiY 0) (> szybkoscKulkiX 0))
     (progn
       (setq szybkoscKulkiX (+ szybkoscKulkiX 0.2))
       (setq szybkoscKulkiY (+ szybkoscKulkiY 0.2))
     )
  )
)
;end wstrzasStolu
;##################################################################

;##################################################################
;funkcja wykonywana podczas restartu gry (klawisz s):
(defun restart ()
	(print "kulka zostaje wystrzelona!")
	(setq szybkoscKulkiY szybkoscPoczatkowaKulki)
	(setq szybkoscKulkiX 0)
	(vla-put-position kulka (vlax-3d-point (list 570 70 16)) )
	(vla-put-center obwKulki (vlax-3d-point (list 570 70 16)) )
)
;end restart
;##################################################################

;##################################################################
;ruch dzwigni prawej:
(defun ruchPrawa ()
          (setq p1 '(382.0411 124.4692 0.0))
          (setq p2 '(382.0411 124.4692 -50))
          (if (< licznikX iloscRuchow)
	    (progn
	      (rotate3d dzwigniaPrawa p1 p2 kat)
	      (rotate3d obwDzwigniP p1 p2 kat)
	    )
	    (progn
	      (rotate3d dzwigniaPrawa p1 p2 (* kat -1))
	      (rotate3d obwDzwigniP p1 p2 (* kat -1))
	    )
	  )

 (vlax-for item *ModelSpace*
  (if (= (vlax-get-property item 'Layer) "obwDzwigniP")
    (setq obwDzwigniP1 item)
  )
 )
)
;end ruchPrawa
;##################################################################

;##################################################################
;ruch dzwigni lewej:           
(defun ruchLewa ()
       (setq p1 '(217.9589 124.4692 0.0))
       (setq p2 '(217.9589 124.4692 -50))
       (if (< licznikZ iloscRuchow)
	 (progn
           (rotate3d dzwigniaLewa p1 p2 (* kat -1))
	   (rotate3d obwDzwigniL p1 p2 (* kat -1))
	 )
	 (progn
           (rotate3d dzwigniaLewa p1 p2 kat)
	   (rotate3d obwDzwigniL p1 p2 kat) 
	 )
       )
   (vlax-for item *ModelSpace*
    (if (= (vlax-get-property item 'Layer) "obwDzwigniP")
      (setq obwDzwigniL1 item)
    )
   )
 )
;end ruchLewa
;##################################################################

;##################################################################
;funkcja zerujaca wcisniecie klawisza x - po nacisnieciu
;klawisza x program przechodzi do animacji prawej dzwigni
;dopiero po zakonczeniu animacji (czyli wyzerowaniu x)
;program moze wychwycic kolejne nacisniecie x
;ta funkcja zeruje odpowiednie flagi
(defun zerujX ()
 	(print "wyzerowano X")
	(setq wcisnietoX 0)
	(setq licznikX 0)
)
;end zerujX
;##################################################################

;##################################################################
;funkcja zerujaca wcisniecie klawisza z - po nacisnieciu
;klawisza z program przechodzi do animacji lewej dzwigni
;dopiero po zakonczeniu animacji (czyli wyzerowaniu z)
;program moze wychwycic kolejne nacisniecie z
;ta funkcja zeruje odpowiednie flagi
(defun zerujZ ()
  	(print "wyzerowano Z")
	(setq wcisnietoZ 0)
	(setq licznikZ 0)
)
;end zerujZ
;##################################################################

;##################################################################
;funkcja odpowiadajaca za ruch i fizyke kuli:
(defun ruszKulka ()
  (setq kolizjaDzwigniaKulka 0)
  (ladujKulke)
  (sprawdzKolizjeBoki)
  (sprawdzKolizjeLewa)
  (sprawdzKolizjePrawa)
  (sprawdzIloscPktKolizji)
  (if (and (= kolizjaWykryta 1) (> zabezpieczenie 5))
    (progn
      (przeliczSzybkosc)
      (dodajPunkty)
    )
  )
  (if (= kolizjaDzwigniaKulka 1)
    (progn
      (przesunKulke)(przesunKulke)(przesunKulke)(przesunKulke)
    )
  )
  (przesunKulke)
  (sprawdzGameOver)
)
;end ruszkulka
;##################################################################

;##################################################################
(defun dodajPunkty ()
  (foreach item punkty10
  (setq pktKolizjiS (vla-IntersectWith obwKulki item acExtendNone))
  (setq pktKolizjiLista (lisp-value pktKolizjiS))
     (if (/= pktKolizjiLista nil)
      (progn
        (print "Dodano 10 pkt")
	(setq sumaPkt (+ sumaPkt 10))
        (print "Masz juz: ")
	(princ sumaPkt) (princ " pkt")
      )
     )
  )
)
;##################################################################

;##################################################################
(defun sprawdzGameOver ()
  (setq pktKolizjiS (vla-IntersectWith obwKulki deathLine acExtendNone))
     (setq pktKolizjiLista (lisp-value pktKolizjiS))
     (if (/= pktKolizjiLista nil)
      (progn
        (print "Game Over !!!")
	(setq iii 0)
      )
     )
)
;##################################################################

;##################################################################
;sprawdza kolizje z prawa dzwignia
(defun sprawdzKolizjePrawa ()
     (setq pktKolizjiS (vla-IntersectWith obwKulki obwPrawejDzwigni acExtendNone))
     (setq pktKolizjiLista (lisp-value pktKolizjiS))
     (if (/= pktKolizjiLista nil)
      (progn
        (print "kolizja z prawa dzwignia!!!")
        (setq kolizjaWykryta 1)
	(setq pktKolTemp (append pktKolTemp pktKolizjiLista))
	(setq kolizjaDzwigniaKulka 1)
      )
     )
)
;end sprawdzKolizjePrawa
;##################################################################

;##################################################################
;sprawdza kolizje z lewa dzwignia
(defun sprawdzKolizjeLewa ()
     (setq pktKolizjiS (vla-IntersectWith obwKulki obwLewejDzwigni acExtendNone))
     (setq pktKolizjiLista (lisp-value pktKolizjiS))
     (if (/= pktKolizjiLista nil)
      (progn
        (print "kolizja z lewa dzwignia!!!")
        (setq kolizjaWykryta 1)
	(setq pktKolTemp (append pktKolTemp pktKolizjiLista))
	(setq kolizjaDzwigniaKulka 1)
      )
     )
)
;end sprawdzKolizjeLewa
;##################################################################

;##################################################################
;funkcja sprawdza kolizje z obiektami z kolekcji obwBokow
(defun sprawdzKolizjeBoki ()
  (foreach item obwBokow
    (setq pktKolizjiS (vla-IntersectWith obwKulki item acExtendNone))
    (setq pktKolizjiLista (lisp-value pktKolizjiS))
    (if (/= pktKolizjiLista nil)
      (progn
        (setq kolizjaWykryta 1)
	(setq pktKolTemp (append pktKolTemp pktKolizjiLista))
      )
    )
  )
)
;sprawdzKolizjeBoki
;##################################################################

;##################################################################
;funkcja ladujaca wlasciwosci kulki
(defun ladujKulke ()
  (setq insPoint (vla-get-position kulka))
  (setq insPointV (vlax-safearray->list(vlax-variant-value insPoint) ))
  (setq x (nth 0 insPointV)) 
  (setq y (nth 1 insPointV))  
  (setq z (nth 2 insPointV))  
  (setq pktKolTemp nil)
  (setq kolizjaWykryta 0)
  (setq zabezpieczenie 0)
)
;end ladujKulke
;##################################################################

;##################################################################
;funkcja liczaca ilosc pozycji w liscie z kunktami kolizji
;gdy wykryto dwa punkty kolizji to zabezpieczenie = 6
;wtedy program moze liczyc kolizje
(defun sprawdzIloscPktKolizji ()
     (setq zabezpieczenie 0)
  (foreach item pktKolTemp
     (setq zabezpieczenie (+ zabezpieczenie 1))
  )
)
;end sprawdzIloscPktKolizji
;##################################################################

;##################################################################
;funkcja przesuwajaca kulke o jej szybkosc
(defun przesunKulke ()
  (vla-put-position kulka (vlax-3d-point (list (+ x szybkoscKulkiX) (+ y szybkoscKulkiY) (+ z 0))) )
  (vla-put-center obwKulki (vlax-3d-point (list (+ x szybkoscKulkiX) (+ y szybkoscKulkiY) (+ z 0))) )
)
;end przesunKulke
;##################################################################

;##################################################################
;funkcja przeliczajaca szybkosz x i y kulki
(defun przeliczSzybkosc ()
        ;z ksiazki obliczenia
        ;Vi =  (szybkoscKulkiX , szybkoscKulkiY)
        ;B  =  (xb , yb)
          ;xb = (nth 3 pktKolTemp) - (nth 0 pktKolTemp)
          ;yb = (nth 4 pktKolTemp) - (nth 1 pktKolTemp)
        (setq xb (- (nth 3 pktKolTemp) (nth 0 pktKolTemp)))
        (setq yb (- (nth 4 pktKolTemp) (nth 1 pktKolTemp)))
        ;N = (yb, -xb)
        (setq normalizacja (sqrt (+ (* yb yb) (* (* xb -1) (* xb -1)) )))
        (setq xn (/ yb normalizacja))
        (setq yn (/ (* xb -1) normalizacja))
        (setq pp1 (+ (* xn (* szybkoscKulkiX -1)) (* yn (* szybkoscKulkiY -1)) ))
        (setq xp (* pp1 xn))
        (setq yp (* pp1 yn))
        (setq szybkoscKulkiX (+ (* 2 xp) szybkoscKulkiX))
        (setq szybkoscKulkiY (+ (* 2 yp) szybkoscKulkiY))
      ;koniec obliczen z ksiazki
)
;end przeliczSzybkosc
;##################################################################

;##################################################################
;funkcja znaleziona w internecie, sprawdza, czy safearray jest pusta
;jesli tak zwraca nil, jesli nie zwraca jej wartosc
;wykorzystanie jej w programie bylo konieczne do pozbycia
;sie bledu spowodowanego proba przekszta³cenia saffearraj
;o wartosci nil do listy - w przypadku nil wyskakiwal blad
;uzycie instrukcji warunkowej oraz funkcji lisp-value eliminuje ten blad

(defun lisp-value (v) ; the Holy Graal of vla->lisp conversion? ;-)
;; Copyright 2002 Vladimir Nesterovsky.
;; Free for use by any commercial entity with
;; less then $100 million annual revenue.
(cond
((= (type v) 'variant) (lisp-value (variant-value v)))
((= (type v) 'safearray) (mapcar 'lisp-value (safearray-value v)))
(T v)))
;##################################################################
;(vlr-beep-reaction) dzwiek

;##################################################################
;funkcja
(defun koniecGry ()
  (setq iiii 1)
  (przywrocPozycjeDzwigni)
  (print "Gra skonczona, nacisnij ESC by wyjsc")
  (while (= iiii 1)
    (setq tempList (grread T 5 2))
  )
  (print "Program zakonczyl dzialanie!")
)
;end koniecGry
;##################################################################

;##################################################################
;funkcja po zakonczeniu gry przywraca dzwignie na odpowiednie pozycje
(defun przywrocPozycjeDzwigni ()
  (while (/= licznikX 0)
        (ruchPrawa)
	(setq licznikX (+ licznikX 1))
	(if (= licznikX (* iloscRuchow 2))
	  (zerujX)
        )
   )
  (while (/= licznikZ 0)
        (ruchLewa)
	(setq licznikZ (+ licznikZ 1))
	(if (= licznikZ (* iloscRuchow 2))
	  (zerujZ)
        )
   )
)
;end przywrocPozycjeDzwigni
;##################################################################

