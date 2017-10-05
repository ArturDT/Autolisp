
(vl-load-com)
(setq *acadobj* (vlax-get-acad-object))
(setq *ActiveDocument* (vla-get-activedocument *acadobj*))
(setq *ActiveViewPort* (vla-get-ActiveViewPort *ActiveDocument*))


(vla-split *ActiveViewPort* acViewport4)
(vla-put-ActiveViewPort *ActiveDocument* *ActiveViewPort*)
;-----------------------------------------------------------
(setq mspace (vla-get-modelspace *ActiveDocument*))
(vlax-for item mspace
	   (if (= (vlax-get-property item 'ObjectName) "AcDbCircle")
	     (setq circles (append circles (list item)))
	     
	    )
)
(setq promien (vlax-get-property (nth 0 circles) 'Radius))
(setq srodek (vlax-safearray->list(vlax-variant-value(vlax-get-property (nth 0 circles) 'Center))))
;-----------------------------------------------------------
(setq widoki nil)
(setq widoki (vla-get-viewports *ActiveDocument*))
(vlax-for item widoki
  (setq viewlist(append viewlist(list item))))


  (setq prawagorna(nth 0 viewlist))
  (vla-put-Direction prawagorna (vlax-3d-point '(0.0 0.0 0.0)))
  (vla-put-height prawagorna promien)
  (vla-put-width prawagorna promien)
  (setq p1 (+ (nth 0 srodek) (/ promien 2)))
  (setq p2 (+ (nth 1 srodek) (/ promien 2)))
  (vla-put-Center prawagorna  (ConvList_to_VariantArray  (list p1 p2)  vlax-vbDouble))
  (vla-put-ActiveViewPort *ActiveDocument* prawagorna)

  (setq prawadolna(nth 1 viewlist))
  (vla-put-Direction prawadolna (vlax-3d-point '(0.0 0.0 0.0)))
  (vla-put-height prawadolna promien)
  (vla-put-width prawadolna promien)
  (setq p1 (+ (nth 0 srodek) (/ promien 2)))
  (setq p2 (- (nth 1 srodek) (/ promien 2)))
  (vla-put-Center prawadolna  (ConvList_to_VariantArray  (list p1 p2)  vlax-vbDouble))
  (vla-put-ActiveViewPort *ActiveDocument* prawadolna)

  (setq lewagorna(nth 2 viewlist))
  (vla-put-Direction lewagorna (vlax-3d-point '(0.0 0.0 0.0)))
  (vla-put-height lewagorna promien)
  (vla-put-width lewagorna promien)
  (setq p1 (- (nth 0 srodek) (/ promien 2)))
  (setq p2 (+ (nth 1 srodek) (/ promien 2)))
  (vla-put-Center lewagorna  (ConvList_to_VariantArray  (list p1 p2)  vlax-vbDouble))
  (vla-put-ActiveViewPort *ActiveDocument* lewagorna)

  (setq lewadolna(nth 3 viewlist))
  (vla-put-Direction lewadolna (vlax-3d-point '(0.0 0.0 0.0)))
  (vla-put-height lewadolna promien)
  (vla-put-width lewadolna promien)
  (setq p1 (- (nth 0 srodek) (/ promien 2)))
  (setq p2 (- (nth 1 srodek) (/ promien 2)))
  (vla-put-Center lewadolna  (ConvList_to_VariantArray  (list p1 p2)  vlax-vbDouble))
  (vla-put-ActiveViewPort *ActiveDocument* lewadolna)


;-----------------------------------------------------------------------------
(vla-ZoomAll *acadobj*)

(vla-split *ActiveViewPort* acViewport2Horizontal); dzieli poziomo
(vla-split *ActiveViewPort* acViewport2Vertical); dzieli pionowo
(vla-split *ActiveViewPort* acViewport3Left); na 3, lewy dzielony
(vla-split *ActiveViewPort* acViewport3right); na 3, prawy dzielony
(vla-split *ActiveViewPort* acViewport3Horizontal); na 3 poziomo
(vla-split *ActiveViewPort* acViewport3Vertical); na 3 w pionie
(vla-split *ActiveViewPort* acViewport3Above); na 3, dolny dzielony
(vla-split *ActiveViewPort* acViewport3Below); na 3, górny dzielony
(vla-split *ActiveViewPort* acViewport4); na 4

(vla-put-ActiveViewPort *ActiveDocument* *ActiveViewPort*)
(vlaX-dump-object *ActiveViewPort* T)

;(1.0 0.0 0.0); – widok z prawej
;(-1.0 0.0 0.0); – widok z lewej
;(0.0 1.0 0.0); – widok z ty³u
;(0.0 -1.0 0.0); – widok z przodu
;(0.0 0.0 0.0);  – widok z góry
;(0.0 0.0 -1.0); – widok z do³u
;(-1.0 -1.0 1.0); – widok SW iso
;(1.0 -1.0 1.0); – widok SE iso
;(1.0 1.0 1.0); – widok NE iso
;(-1.0 1.0 1.0); – widok NW iso 

(vla-put-Direction *ActiveViewPort* (vlax-3d-point '(-1.0 -1.0 1.0)))
(vla-put-ActiveViewPort *ActiveDocument* *ActiveViewPort*)
(vla-ZoomAll *acadobj*)

(setq viewslst nil)
(setq *Views* (vla-get-Views *ActiveDocument*))
(vlax-for view *Views*
  (setq viewslst (append (list view) viewslst))
  ) 

(vla-Add *Views* "jakzkamery")

(setq jakzkamery (nth 0 viewslst))
(vla-put-Target jakzkamery (vlax-3d-point '(0.0 0.0 1.0)))
(vla-put-Direction jakzkamery (vlax-3d-point '(-2.5 2.5 5.0)))
(vla-SetView *ActiveViewPort* jakzkamery)
(vla-put-ActiveViewPort *ActiveDocument* *ActiveViewPort*)

(vla-put-Center  viewport (ConvList_to_VariantArray  (list 0.0 0.0)  vlax-vbDouble))




;;;; #######################################################################################################################################
;;;;      ConvList_to_VariantArray     ConvList_to_VariantArray     ConvList_to_VariantArray     ConvList_to_VariantArray     ConvList_to_V
;;;; CALL: (ConvList_to_VariantArray  *SelObjIDsList*  vlax-vbLong)                 ;;;(setq InList *SelObjIDsList*)  (setq SAType vlax-vbLong)

(defun ConvList_to_VariantArray (InList SAType /  LengthList iCount iList)

	(setq LengthList (length InList))
	(setq OutSaveArray (vlax-make-safearray SAType (cons 0 (1- LengthList) )))  ;;;   '(l-bound . u-bound)
        (setq iCount 0)
  	(repeat  LengthList
 		(setq iList (nth iCount InList))
    		(vlax-safearray-put-element OutSaveArray  iCount  iList)
    
    	(setq iCount (1+ iCount))
  	); end repeat

  (vlax-make-variant   OutSaveArray )			; return this value.
); end defun ConvList_to_VariantArray

;;;;( setq RetVal (ConvList_to_VariantArray  *SelObjIDsList* vlax-vbLong))


;;;;      ConvList_to_VariantArray     ConvList_to_VariantArray     ConvList_to_VariantArray     ConvList_to_VariantArray     ConvList_to_Va
;;;; #######################################################################################################################################