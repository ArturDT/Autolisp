;;;; #######################################################################################################################################
;;;;      ConvList_to_SaveArray     ConvList_to_SaveArray     ConvList_to_SaveArray     ConvList_to_SaveArray     ConvList_to_SaveArray     
;;;; CALL: (ConvList_to_SaveArray  *SelObjIDsList*  vlax-vbLong)                 ;;;(setq InList *SelObjIDsList*)  (setq SAType vlax-vbLong)
;;;;(setq InList (list 1.0 2.0 3.0)) (setq SAType vlax-vbDouble)
(defun ConvList_to_SaveArray (InList SAType /  LengthList iCount iList)

	(setq LengthList (length InList))
	(setq OutSaveArray (vlax-make-safearray SAType (cons 0 (1- LengthList) )))  ;;;   '(l-bound . u-bound)
        (setq iCount 0)
  	(repeat  LengthList
 		(setq iList (nth iCount InList))
    		(vlax-safearray-put-element OutSaveArray  iCount  iList)
    
    	(setq iCount (1+ iCount))
  	); end repeat

  (setq *ObjIDs* OutSaveArray)			; return this value.
); end defun ConvList_to_SaveArray

;;;;( setq RetVal (ConvList_to_SaveArray  *SelObjIDsList* vlax-vbLong))


;;;;      ConvList_to_SaveArray     ConvList_to_SaveArray     ConvList_to_SaveArray     ConvList_to_SaveArray     ConvList_to_SaveArray     
;;;; #######################################################################################################################################



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