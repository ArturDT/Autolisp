
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
  (setq p11 (+ (nth 0 srodek) (/ promien 2)))
 (setq p11 (- p11 42))
  (setq p21 (+ (nth 1 srodek) (/ promien 2)))
 (setq p21 (+ p21 6.5))
  (vla-put-Center prawagorna  (ConvList_to_VariantArray  (list p11 p21)  vlax-vbDouble))
  (vla-put-ActiveViewPort *ActiveDocument* prawagorna)

  (setq prawadolna(nth 1 viewlist))
  (vla-put-Direction prawadolna (vlax-3d-point '(0.0 0.0 0.0)))
  (vla-put-height prawadolna promien)
  (vla-put-width prawadolna promien)
  (setq p12 (+ (nth 0 srodek) (/ promien 2)))
 (setq p12 (- p12 42))
  (setq p22 (- (nth 1 srodek) (/ promien 2)))
 (setq p22 (+ p22 6.5))
  (vla-put-Center prawadolna  (ConvList_to_VariantArray  (list p12 p22)  vlax-vbDouble))
  (vla-put-ActiveViewPort *ActiveDocument* prawadolna)

  (setq lewagorna(nth 2 viewlist))
  (vla-put-Direction lewagorna (vlax-3d-point '(0.0 0.0 0.0)))
  (vla-put-height lewagorna promien)
  (vla-put-width lewagorna promien)
  (setq p13 (- (nth 0 srodek) (/ promien 2)))
 (setq p13 (- p13 59))
  (setq p23 (+ (nth 1 srodek) (/ promien 2)))
 (setq p23 (+ p23 6.5))
  (vla-put-Center lewagorna  (ConvList_to_VariantArray  (list p13 p23)  vlax-vbDouble))
  (vla-put-ActiveViewPort *ActiveDocument* lewagorna)

  (setq lewadolna(nth 3 viewlist))
  (vla-put-Direction lewadolna (vlax-3d-point '(0.0 0.0 0.0)))
  (vla-put-height lewadolna promien)
  (vla-put-width lewadolna promien)
  (setq p14 (- (nth 0 srodek) (/ promien 2)))
 (setq p14 (- p14 59))
  (setq p24 (- (nth 1 srodek) (/ promien 2)))
 (setq p24 (+ p24 6.5))
  (vla-put-Center lewadolna  (ConvList_to_VariantArray  (list p14 p24)  vlax-vbDouble))
  (vla-put-ActiveViewPort *ActiveDocument* lewadolna)


;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------






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