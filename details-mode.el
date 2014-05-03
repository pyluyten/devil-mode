;(require 'evil-mode)

; A. emacs-state cursor amended
; B. normal mode switches to emacs for a A i I o O
;    as does c.
; C. visual mode uses cua (x "cut", c "copy)
; D. use i j k l. Rather than i, use SPC to insert. Rather than I, use h.
; E. Have emacs TAB go to vi state. Probably way too broken.


; TODO selections: evil-visual-char evil-visual-line evil-visual-block

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

(defun details-block ()
  (interactive)
  (evil-emacs-state)
  (cua-set-rectangle-mark)
)


 (evil-define-operator details-change (beg end)
     "Change selected text."
    (kill-region beg end)
    (evil-emacs-state)
 )



(evil-set-initial-state 'Emacs-Lisp 'emacs) ; marche pas.


; redefine i h k l. Nah, l is fine.
(define-key evil-normal-state-map "i" 'evil-previous-line)
(define-key evil-normal-state-map "k" 'evil-next-line)
(define-key evil-normal-state-map "j" 'evil-backward-char)


(define-key evil-normal-state-map "h" 'details-insert-line)
(define-key evil-normal-state-map "a" 'details-append)
(define-key evil-normal-state-map "A" 'details-append-line)
(define-key evil-normal-state-map "o" 'details-insert-below)
(define-key evil-normal-state-map "O" 'details-insert-above)
(define-key evil-emacs-state-map (kbd "M-SPC") 'evil-normal-state)
(define-key evil-emacs-state-map (kbd "TAB") 'evil-normal-state)
(define-key evil-normal-state-map (kbd "SPC") 'evil-emacs-state)
(define-key evil-visual-state-map "x" 'kill-region)
(define-key evil-visual-state-map "c" 'kill-ring-save)
(define-key evil-normal-state-map "c" 'details-change)
(define-key evil-normal-state-map (kbd "C-RET") 'details-block)

(provide 'details-mode)
