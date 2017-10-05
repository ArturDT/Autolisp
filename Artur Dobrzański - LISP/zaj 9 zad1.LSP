
(vl-load-com)
(setq aplikacja (vlax-get-acad-object))
(vl-load-com)
(setq aplikacja (vlax-get-acad-object))
(vlax-dump-object aplikacja T)
(setq aktywny (vla-get-activedocument aplikacja))
(setq mspace (vla-get-modelspace aktywny))
(setq item (vla-item mspace 0))
(setq block_list nil)
(vlax-for item mspace
  (if (and (= (vlax-get-property item 'ObjectName) "AcDbBlockReference") (= (vla-get-HasAttributes item) :vlax-true) )
	(setq block_list (append block_list (list item)))
  )
)
;-----------------------------------------------
;1.   napisaæ fukcjê, która dla wybranego bloku utworzy listê nazw atrybutów (attribute Tag) 
;	oraz listê list, której elementami s¹ nazwa atrybutu (attribute Tag) - TagString 
;	i wartoœæ atrybutu (attribute Text) – TextString
;---------------zad1:---------------------------
(print "wpisz numer bloku 0-68")
(setq wskazanie_usera (getint))
(setq wskazanyBlok (nth wskazanie_usera block_list))
(setq atrybuty_list nil)
(setq nazwa_list nil)
(setq druga_list nil)
(if (= (vla-get-HasAttributes wskazanyBlok) :vlax-true)
  (progn
    (setq atrybuty_variant (vla-GetAttributes wskazanyBlok))
    (setq atrybuty_safearray (vlax-variant-value atrybuty_variant))
    (setq atrybuty_list (vlax-safearray->list atrybuty_safearray))
    (foreach atrybut atrybuty_list
	(setq nazwa_list nil)
	(setq nazwa_list (append nazwa_list (list (vla-get-TagString atrybut))))
    	(setq nazwa_list (append nazwa_list (list (vla-get-textstring atrybut))))
        (setq druga_list (append druga_list (list nazwa_list)))
    )
  )
  (print "wskazany blok nie posiada atrybutów")
)

;-----------------------------------------------
;2.   napisaæ funkcjê, która utworzy listê list
;(tak¹ jak w poprzednim zadaniu) dla wszystkich bloków w rysunku
;---------------zad2:---------------------------
(setq zad2_list nil)
(setq atrybuty_list_all nil)
(foreach blok block_list
  (if (= (vla-get-HasAttributes blok) :vlax-true)
    (progn
      (setq atrybuty2_variant (vla-GetAttributes blok))
      (setq atrybuty2_safearray (vlax-variant-value atrybuty2_variant))
      (setq atrybuty2_list (vlax-safearray->list atrybuty2_safearray))
      (setq druga_list_all nil)
      (foreach atrybut atrybuty2_list
	(setq nazwa_list nil)
	(setq nazwa_list (append nazwa_list (list (vla-get-TagString atrybut))))
    	(setq nazwa_list (append nazwa_list (list (vla-get-textstring atrybut))))
        (setq druga_list_all (append druga_list_all (list nazwa_list)))
      )
      (setq atrybuty_list_all (append atrybuty_list_all (list atrybuty2_list)))
      (setq zad2_list (append zad2_list (list druga_list_all)))
    )
  )
)
;-----------------------------------------------
;3.   napisaæ funkcjê, która pozwoli u¿ytkownikowi wybraæ blok, wylistuje jego atrybuty, 
;	 pozwoli wybraæ jeden z nich, a nastêpnie doda do selekcji wszystkie bloki, 
;	 dla których ten atrybut ma tê sam¹ wartoœæ.
;---------------zad3:---------------------------
(setq selekcja_test nil)
(setq selekcja1 nil)
(print "wskaz blok (0-68):")
(setq wskazanie_usera (getint))
(print "wybierz atrybut:")
(setq i 0)
(foreach item (nth wskazanie_usera zad2_list)
  (print i)(prin1 " ") (prin1 (nth 0 item)) (prin1 "  ")(prin1 (nth 1 item))
  (setq i (+ i 1))
)
(print "wybierz atrybut z listy powyzej ")
(setq wybrany_atr (getint))
;--
(setq x 0)
(foreach item zad2_list
  (foreach poditem item
    (if (and (= (nth 0 poditem) (nth 0 (nth wybrany_atr (nth wskazanie_usera zad2_list))))
	     (= (nth 1 poditem) (nth 1 (nth wybrany_atr (nth wskazanie_usera zad2_list)))))
      (progn
      (setq selekcja_test (append selekcja_test (list (nth x atrybuty_list_all) )))
      (setq selekcja1 (append selekcja1 (list (nth x block_list) )))
      )
    )
  )
  (setq x (+ x 1))
)

;---
;(setq *SelectionSets* (vla-get-SelectionSets aktywny)) ; pobranie kolekcji selectionsets
;(vla-Add *SelectionSets* "SelSet01") ; dodanie do kolekcji nowego selset o nazwie SelSet01
;Pobranie z kolekcji selset:
;(setq SelSet (vla-item *SelectionSets* "SelSet01")) ;przez nazwe SelSet01
;-----
(setq NObj (length selekcja1)); sprawdzenie d³ugoœci listy
;zmiana listy na variant typu SafeArray:
(setq SelObjArray (vlax-make-safearray vlax-vbObject (cons 0 (1- NObj) )))
(setq iCount 0)
(repeat NObj
(setq iElement (nth iCount selekcja1))
(vlax-safearray-put-element SelObjArray iCount iElement)
(setq iCount (1+ iCount)))
(setq SelObjArrayVar (vlax-make-variant SelObjArray))

;dodanie SelSet z selekcj¹
(vla-AddItems SelSet SelObjArrayVar)
;-----------------------------------------------

;(vla-get-HasAttributes pierwszyblok)
;(setq atrybuty_variant (vla-GetAttributes pierwszyblok))
;(setq atrybuty_safearray (vlax-variant-value atrybuty_variant))
;(setq atrybuty_list (vlax-safearray->list atrybuty_safearray))

;(setq pierwszyatrybut (nth 0 atrybuty_list))

;(setq tagstring (vla-get-TagString pierwszyatrybut))
;(setq textring (vla-get-textstring pierwszyatrybut))