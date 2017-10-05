(vl-load-com)
(setq *AcadApp* (vlax-get-acad-object))
(setq *ActiveDocument* (vla-get-activedocument *AcadApp*))

;(vla-Delete Selset)
(setq *SelectionSets* (vla-get-SelectionSets *ActiveDocument*)) ; pobranie kolekcji selectionsets
(vla-Add *SelectionSets* "SelSet01") ; dodanie do kolekcji nowego selset o nazwie SelSet01
 
;Pobranie z kolekcji selset:
(setq SelSet (vla-item *SelectionSets* "SelSet01")) ;przez nazwe SelSet01
(setq SelSet (vla-item *SelectionSets* 0)) ; przez numer
; albo przez vlax-for
 
;Przyk³ad dodania selset:
;utworzenie pustego selset o nazwie SelSet01
(setq so1 (vlax-ename->vla-object (car(entsel)))); wybor obiektu 1
(setq so2 (vlax-ename->vla-object (car(entsel)))); wybor obiektu 2


(setq ObjList (list so1 so2)); utworzenie listy wybranych elementów
(setq NObj (length ObjList)); sprawdzenie d³ugoœci listy


;zmiana listy na variant typu SafeArray:
(setq SelObjArray (vlax-make-safearray vlax-vbObject (cons 0 (1- NObj) )))
(setq iCount 0)
(repeat NObj
(setq iElement (nth iCount ObjList))
(vlax-safearray-put-element SelObjArray iCount iElement)
(setq iCount (1+ iCount)))
(setq SelObjArrayVar (vlax-make-variant SelObjArray))

;dodanie SelSet z selekcj¹
(vla-AddItems SelSet SelObjArrayVar)


;dodatkowe operacje:
;(vla-Clear SelSet); czysci SelSet
;(vla-Delete (nth 0 selsetlist)); usuwa SelSet z *SelectionSets*
;(vla-Erase SelSet); usuwa z rysunku elementy zawarte w SelSet
;(vla-Highlight SelSet T); zaznacza elementy zawarte w SelSet w rysunku
;(vla-RemoveItems SelSet Selection) - usuwa z SelSet selekcjê: Selection - variant typu safearray