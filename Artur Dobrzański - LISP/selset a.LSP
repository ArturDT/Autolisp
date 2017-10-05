;a) Utworzyæ sset o nazwie sel_all sk³adaj¹cy siê z wszyskich elementów rysunku,
;utworzyæ sset o nazwie user_pick sk³adaj¹cych siê z elementów wskazanych przez
;u¿ytkownik na rysunku (wykorzystaæ funkcjê entsel). Utworzyæ tymczasowy sset
;o nazwie sel_tmp i przypisaæ do niego wszystkie elementy w sel_all z pominiêciem user_pick
(vl-load-com)
(setq *AcadApp* (vlax-get-acad-object))
(setq *ActiveDocument* (vla-get-activedocument *AcadApp*))
(setq *SelectionSets* (vla-get-SelectionSets *ActiveDocument*)) ; pobranie kolekcji selectionsets
(vla-Add *SelectionSets* "sel_all")
(vla-Add *SelectionSets* "user_pick")
(vla-Add *SelectionSets* "sel_tmp")
(vla-Add *SelectionSets* "sel_circle")
(vla-Add *SelectionSets* "sel_and")

;Utworzenie sset o nazwie sel_all:
(setq selset (ssget "x"))
(setq sel_all nil)
(setq licznik 0)
(repeat (sslength selset)
  (setq obj (vlax-ename->vla-object (ssname selset licznik) ))
  (setq sel_all (append sel_all (list obj))) 
  (setq licznik (1+ licznik))
)

;utworzenie sset o nazwie user_pick:
(setq user_pick nil)
(print "ile obiektow chcesz wybrac?")
(setq ile_zaznacz (getint))
(repeat ile_zaznacz
	(setq obj (vlax-ename->vla-object (car(entsel))))
  	(setq user_pick (append user_pick (list obj)))
)

;utworzenie sset o nazwie sel_tmp:
(setq sel_tmp nil)
(setq licznik 0)
(repeat (sslength selset)
 (setq tester 0)
 (setq ii 0)
 (repeat ile_zaznacz  
   (if (= (vlax-get-property (nth ii user_pick) 'ObjectID) (vlax-get-property (nth licznik sel_all) 'ObjectID))
     (setq tester 1)
   )
   (setq ii (+ ii 1))
 )
 (if (= tester 0)
   (setq sel_tmp (append sel_tmp (list (nth licznik sel_all))))
 )
 (setq licznik (+ licznik 1))
)

(setq sel_tmp_zad_a sel_tmp)
;b) Usun¹æ z sel_tmp wszystkie kwadraty i elementy z wartwy green.
;wyœwietliæ sel_tmp na rysunku

;usuwanie kwadratow z sel_tmp:
;zeby sprawdzic czy dana polilinia tworzy kwadrat mozna uzyc wzoru:
; (d/4)^2 = p  (d - dlugosc polilini, p - pole)
;jesli pole obliczone z tego wzoru rowne jest polu figury to jest to kwadrat
(setq licznik 0)
(setq temp nil)
(setq test 0)
(repeat (length sel_tmp)
 (if (= (vlax-get-property (nth licznik sel_tmp) 'Layer) "green");usuniecie z select elementow na warstwie green
  (setq test 1)
  (progn
   (if (= (vlax-get-property (nth licznik sel_tmp) 'ObjectName) "AcDbPolyline")
    (progn
     (setq d (vlax-get-property (nth licznik sel_tmp) 'Length))
     (setq area (/ d 4))
     (setq area (* area area))
     (setq p (vlax-get-property (nth licznik sel_tmp) 'Area))
     (if (= area p)
      (setq test 1)
     )
    )
   )
  )
 )
 (if (= test 0)
   (setq temp (append temp (list (nth licznik sel_tmp))))
 )
 (setq licznik (+ licznik 1))
 (setq test 0)
)
(setq sel_tmp temp)

(setq NObj (length sel_tmp)); sprawdzenie d³ugoœci listy
;zmiana listy na variant typu SafeArray:
(setq SelObjArray nil)(setq SelObjArrayVar nil)
(setq SelSet_tmp (vla-item *SelectionSets* "sel_tmp"))
(setq SelObjArray (vlax-make-safearray vlax-vbObject (cons 0 (1- NObj) )))
(setq iCount 0)
(repeat NObj
 (setq iElement (nth iCount sel_tmp))
 (vlax-safearray-put-element SelObjArray iCount iElement)
 (setq iCount (1+ iCount))
)
 (setq SelObjArrayVar (vlax-make-variant SelObjArray))

;dodanie SelSet z selekcj¹
(vla-AddItems SelSet_tmp SelObjArrayVar)
(vla-Highlight SelSet_tmp T)

(setq sel_tmp_zad_b sel_tmp)

;c) Utworzyæ sset o nazwie sel_circle zawieraj¹cy wszystkie okrêgi w rysunku.
;Dokonaæ iloczynu logicznego na ssetach sel_circle i sel_tmp – wynik przypisaæ
;do sel_and a nastêpnie usun¹æ te elementy z rysunku.

;Utworzenie sset o nazwie sel_circle:
(setq sel_circle nil)
(setq licznik 0)
(repeat (sslength selset)
 (if (= (vlax-get-property (nth licznik sel_all) 'ObjectName) "AcDbCircle")
   (setq sel_circle (append sel_circle (list (nth licznik sel_all))))
 )
 (setq licznik (+ licznik 1))
)
;iloczyn and czyli jesli element znajduje sie na obu listach
(setq licznik 0)
(repeat (length sel_circle)
 (setq licznik2 0)
 (repeat (length sel_tmp)
  (if (= (vlax-get-property (nth licznik sel_circle) 'ObjectID) (vlax-get-property (nth licznik2 sel_tmp) 'ObjectID) )
    (setq sel_and (append sel_and (list (nth licznik sel_circle))))
  )
  (setq licznik2 (+ licznik2 1))
 )
 (setq licznik (+ licznik 1))
)


(setq NObj (length sel_and)); sprawdzenie d³ugoœci listy
;zmiana listy na variant typu SafeArray:
(setq SelObjArray nil)(setq SelObjArrayVar nil)
(setq SelSet_and (vla-item *SelectionSets* "sel_and"))
(setq SelObjArray (vlax-make-safearray vlax-vbObject (cons 0 (1- NObj) )))
(setq iCount 0)
(repeat NObj
 (setq iElement (nth iCount sel_and))
 (vlax-safearray-put-element SelObjArray iCount iElement)
 (setq iCount (1+ iCount))
)
 (setq SelObjArrayVar (vlax-make-variant SelObjArray))

;dodanie SelSet z selekcj¹
(vla-AddItems SelSet_and SelObjArrayVar)
;(vla-Erase SelSet_and); usuwa z rysunku elementy zawarte w SelSet










;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 (setq NObj (length sel_all)); sprawdzenie d³ugoœci listy
;zmiana listy na variant typu SafeArray:
(setq SelObjArray nil)(setq SelObjArrayVar nil)
(setq SelSet_all (vla-item *SelectionSets* "sel_all"))
(setq SelObjArray (vlax-make-safearray vlax-vbObject (cons 0 (1- NObj) )))
(setq iCount 0)
(repeat NObj
 (setq iElement (nth iCount sel_all))
 (vlax-safearray-put-element SelObjArray iCount iElement)
 (setq iCount (1+ iCount))
)
 (setq SelObjArrayVar (vlax-make-variant SelObjArray))

;dodanie SelSet z selekcj¹
(vla-AddItems SelSet_all SelObjArrayVar)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq NObj (length sel_circle)); sprawdzenie d³ugoœci listy
;zmiana listy na variant typu SafeArray:
(setq SelObjArray nil)(setq SelObjArrayVar nil)
(setq SelSet_circle (vla-item *SelectionSets* "sel_circle"))
(setq SelObjArray (vlax-make-safearray vlax-vbObject (cons 0 (1- NObj) )))
(setq iCount 0)
(repeat NObj
 (setq iElement (nth iCount sel_circle))
 (vlax-safearray-put-element SelObjArray iCount iElement)
 (setq iCount (1+ iCount))
)
 (setq SelObjArrayVar (vlax-make-variant SelObjArray))

;dodanie SelSet z selekcj¹
(vla-AddItems SelSet_circle SelObjArrayVar)


;iloczyn logiczny

;(setq SelSet_and (vla-item *SelectionSets* "sel_and"))
(setq SelSet_and (and SelSet_circle SelSet_tmp))