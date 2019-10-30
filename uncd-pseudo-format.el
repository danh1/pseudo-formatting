;; There are four functions meant for interactive usage:
;;   uncd-selection-bold
;;   uncd-selection-unbold
;;   uncd-selection-italic
;;   uncd-selection-unitalic
;;
;; Each modifies the selection by changing the unicode code points
;; in the selection to one relating (or not relating) to bold or italic,
;; if any such changes can be found.
;;
;; For example, the text "parabola has origin in παραβολλω" could be
;; transformed to "𝐩𝐚𝐫𝐚𝐛𝐨𝐥𝐚 𝐡𝐚𝐬 𝐨𝐫𝐢𝐠𝐢𝐧 𝐢𝐧 𝛑𝛂𝛒𝛂𝛃𝛐𝛌𝛌𝛚", or
;; "𝑝𝑎𝑟𝑎𝑏𝑜𝑙𝑎 h𝑎𝑠 𝑜𝑟𝑖𝑔𝑖𝑛 𝑖𝑛 𝜋𝛼𝜌𝛼𝛽𝜊𝜆𝜆𝜔", or
;; "𝒑𝒂𝒓𝒂𝒃𝒐𝒍𝒂 𝒉𝒂𝒔 𝒐𝒓𝒊𝒈𝒊𝒏 𝒊𝒏 𝝅𝜶𝝆𝜶𝜷𝝄𝝀𝝀𝝎".  We do not handle accents,
;; and as you can see, since "h" is missing in the italic block, it
;; does not get changed (although it is the only Latin character missing).
;;
;; It performs a change on the text itself, not its format, which is
;; why we call this uncd-pseudo-format (uncd being short for unicode).

(defun uncd-make-hash-pair ( pair-structure-list )
  (let
      (
       (to-cdr (make-hash-table)) (to-car (make-hash-table))
       )
    (dolist
        (pair-structure pair-structure-list)
      (let ((pairs (car pair-structure)) (count (cdr pair-structure)))
        (dotimes (idx count)
          (dolist (pair pairs)
            (let ((k (car pair)) (v (cdr pair)))
              (let ((ke (+ k idx)) (va (+ v idx)))
                (if (char-displayable-p va) (puthash ke va to-cdr))
                (if (char-displayable-p ke) (puthash va ke to-car))))))))
    (cons to-cdr to-car)
    )
  )

(defun uncd-make-bold-hash ( )
  (let
      ((bold-pairs
        (list (cons '((?a . ?𝐚) (?A . ?𝐀) (?𝑎 . ?𝒂) (?𝐴 . ?𝑨)
                      (?𝖺 . ?𝗮) (?𝖠 . ?𝗔) (?𝒶 . ?𝓪) (?𝒜 . ?𝓐)
                      (?𝘢 . ?𝙖) (?𝘈 . ?𝘼) (?𝔞 . ?𝖆) (?𝔄 . ?𝕬)) 26)
              (cons '((?0 . ?𝟎) (?𝟢 . ?𝟬)) 10)
              (cons '((?α . ?𝛂) (?Α . ?𝚨) (?𝛼 . ?𝜶) (?𝛢 . ?𝜜)) 28))))
    (uncd-make-hash-pair bold-pairs)
    )
  )

(defun uncd-make-italic-hash ( )
  (let
      ((italic-pairs
        (list (cons '((?a . ?𝑎) (?A . ?𝐴) (?𝐚 . ?𝒂) (?𝐀 . ?𝑨)
                      (?𝖺 . ?𝘢) (?𝖠 . ?𝘈) (?𝗮 . ?𝙖) (?𝗔 . ?𝘼)) 26)
              (cons '((?α . ?𝛼) (?Α . ?𝛢) (?𝛂 . ?𝜶) (?𝚨 . ?𝜜)) 28))))
    (uncd-make-hash-pair italic-pairs)
    )
  )

(let
    ((bold-hashes (uncd-make-bold-hash) )
     (italic-hashes (uncd-make-italic-hash) ))
  (defvar uncd-internal-to-bold (car bold-hashes))
  (defvar uncd-internal-to-unbold (cdr bold-hashes))
  (defvar uncd-internal-to-italic (car italic-hashes))
  (defvar uncd-internal-to-unitalic (cdr italic-hashes))
  )

(defun uncd-string-to-bold (s)
  (let
      ((ss (substring s 0)))
    (dotimes (idx (length s))
      (let
          ((tgt (gethash (aref ss idx) uncd-internal-to-bold)))
        (if tgt (aset ss idx tgt))
        )
      )
    ss
    )
  )

(defun uncd-string-to-unbold (s)
  (let
      ((ss (substring s 0)))
    (dotimes (idx (length s))
      (let
          ((tgt (gethash (aref ss idx) uncd-internal-to-unbold)))
        (if tgt (aset ss idx tgt))
        )
      )
    ss
    )
  )

(defun uncd-string-to-italic (s)
  (let
      ((ss (substring s 0)))
    (dotimes (idx (length s))
      (let
          ((tgt (gethash (aref ss idx) uncd-internal-to-italic)))
        (if tgt (aset ss idx tgt))
        )
      )
    ss
    )
  )

(defun uncd-string-to-unitalic (s)
  (let
      ((ss (substring s 0)))
    (dotimes (idx (length s))
      (let
          ((tgt (gethash (aref ss idx) uncd-internal-to-unitalic)))
        (if tgt (aset ss idx tgt))
        )
      )
    ss
    )
  )

(defun uncd-selection-bold (start end)
   (interactive "r")
   (if (use-region-p)
       (let
           ((s (delete-and-extract-region start end)))
         (let
             ((s1 (uncd-string-to-bold s)))
           (insert s1)
           )
         )
     )
   )

(defun uncd-selection-unbold (start end)
   (interactive "r")
   (if (use-region-p)
       (let
           ((s (delete-and-extract-region start end)))
         (let
             ((s1 (uncd-string-to-unbold s)))
           (insert s1)
           )
         )
     )
   )

(defun uncd-selection-italic (start end)
   (interactive "r")
   (if (use-region-p)
       (let
           ((s (delete-and-extract-region start end)))
         (let
             ((s1 (uncd-string-to-italic s)))
           (insert s1)
           )
         )
     )
   )

(defun uncd-selection-unitalic (start end)
   (interactive "r")
   (if (use-region-p)
       (let
           ((s (delete-and-extract-region start end)))
         (let
             ((s1 (uncd-string-to-unitalic s)))
           (insert s1)
           )
         )
     )
   )
