; essai de customisation de evil-mode
; pour convenir aux gens convenables

;(require 'evil-mode)

; DONE
; A. emacs-state cursor amended
; B. normal mode switches to emacs for a A i I o O
;    as does c.
; C. visual mode uses cua (x "cut", c "copy)


; TO BE THOUGHT
; M-SPC sucks. I kept ^z but needs something better here.
; is TAB fine?
;
; D. maybe     i
;            j k l       ;; so SPC for i and h for I?


; FIXME - normal mode should have ways to go to 
;         emacs selection mode. CHAR/LINEWISE maybe fine.
;                               not BLOCKWISE
; evil-visual-char
; evil-visual-line
; evil-visual-block > not real time

(setq evil-emacs-state-cursor evil-insert-state-cursor)

(defun details-insert-line ()
  (interactive)
  (beginning-of-line)
  (evil-emacs-state)
)

(defun details-insert-below ()
  (interactive)
  (next-line)
  (evil-emacs-state)
)

(defun details-insert-above ()
  (interactive)
  (previous-line)
  (evil-emacs-state)
)

(defun details-append ()
  (interactive)
  (evil-emacs-state)
  (forward-char 1)
)


(defun details-append-line ()
  (interactive)
  (beginning-of-line)
  (evil-emacs-state)
)


 (evil-define-operator details-change (beg end)
     "Change selected text."
    (kill-region beg end)
    (evil-emacs-state)
 )


(evil-set-initial-state 'Emacs-Lisp 'emacs) ; marche pas.


(define-key evil-normal-state-map "i" 'evil-emacs-state)
(define-key evil-normal-state-map "I" 'details-insert-line)
(define-key evil-normal-state-map "a" 'details-append)
(define-key evil-normal-state-map "A" 'details-append-line)
(define-key evil-normal-state-map "o" 'details-insert-below)
(define-key evil-normal-state-map "O" 'details-insert-above)
(define-key evil-emacs-state-map (kbd "M-SPC") 'evil-normal-state)
(define-key evil-normal-state-map (kbd "SPC") 'evil-emacs-state)
(define-key evil-visual-state-map "x" 'kill-region)
(define-key evil-visual-state-map "c" 'kill-ring-save)
(define-key evil-normal-state-map "c" 'details-change)
 

(provide 'details-mode)
