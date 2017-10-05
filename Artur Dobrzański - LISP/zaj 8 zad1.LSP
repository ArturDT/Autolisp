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


(vl-load-com)
(setq *AcadApp* (vlax-get-acad-object))
(setq *ActiveDocument* (vla-get-activedocument *AcadApp*))
(setq *SelectionSets* (vla-get-SelectionSets *ActiveDocument*)) ; pobranie kolekcji selectionsets
(setq *utility* (vla-get-Utility *ActiveDocument*))

(vla-Add *SelectionSets* "sel_all")
(vla-Add *SelectionSets* "sel")

(setq SelSet (vla-item *SelectionSets* "sel_all"))
(setq SelSet2 (vla-item *SelectionSets* "sel"))
(vla-select SelSet acSelectionSetAll)

(setq FilterType (ConvList_to_VariantArray (list 6) vlax-vbInteger))
;(setq FilterData (ConvList_to_VariantArray (list (vlax-make-variant "ZIGZAG")(vlax-make-variant "ACAD_ISO07W100")(vlax-make-variant "ByLayer")) vlax-vbVariant))
(setq FilterData (ConvList_to_VariantArray (list (vlax-make-variant "ZIGZAG")) vlax-vbVariant))
(setq FilterData2 (ConvList_to_VariantArray (list (vlax-make-variant "ACAD_ISO07W100")) vlax-vbVariant))
(setq FilterData3 (ConvList_to_VariantArray (list (vlax-make-variant "ByLayer")) vlax-vbVariant))
;"ACAD_ISO02W100"
(vla-clear SelSet)
(setq point1 (vla-GetPoint *Utility* nil "p1"))
(setq point2 (vla-GetPoint *Utility* nil "p2"))

;(vla-Select SelSet acSelectionSetAll )
;(vla-SelectOnScreen SelSet FilterType FilterData)

(vla-Select SelSet acSelectionSetCrossing point1 point2 FilterType  FilterData )
(vla-Select SelSet acSelectionSetCrossing point1 point2 FilterType  FilterData2 )
(vla-Select SelSet acSelectionSetCrossing point1 point2 FilterType  FilterData3 )

(vla-Highlight SelSet T)

