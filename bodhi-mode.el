;; todo : document a bit --> info
;;
;;    (require 'bodhi) -> global minor mode
;;    This conflicts with ^o open file.
;;    This conflicts with ^c c to capture.
;;    TAB is not available. Well it goes previous line.
;;
;;    TODO : dired, org. NOT : maggit, ...


;;    /*
;;     *   FIXME
;;     *   end of line, yank line
;;     */

;; is there a way to have a layout? -> ergoEmacs
; note on keys: ^i=TAB, ^m=RET, avoid ? ^h ^[


(require 'cua-base)
(require 'rect)


; ---- vars & assignements -----------

(setq cursor-type 'bar)
(defvar bodhi-selection-state-map nil "Keymap for bodhi selection state")
(defvar bodhi-normal-state-map nil "Keymap for bodhi normal state")

(setq bodhi-normal-state-map (make-sparse-keymap))


; ---- aliases -----------------------


(defalias 'bdh     'bodhi-mode)
(defalias 'one     'delete-other-windows)
(defalias 'eb      'eval-buffer)
(defalias 'w       'save-buffer)
(defalias 'q       'save-buffers-kill-terminal)
(defalias 'vs      'split-window-right)

; ---- commands ----------------------
 

(defun bodhi-copy-from-above (&optional arg)
  "Copy characters from previous nonblank line, starting just above point.
Copy ARG characters, but not past the end of that line.
If no argument given, copy 1 char."
  (interactive "P")
  (let ((cc (current-column))
	n
	(string ""))
    (save-excursion
      (beginning-of-line)
      (backward-char 1)
      (skip-chars-backward "\ \t\n")
      (move-to-column cc)
       (setq n (if arg (prefix-numeric-value-arg) 1))
      ;; If current column winds up in middle of a tab,
      ;; copy appropriate number of "virtual" space chars.
      (if (< cc (current-column))
	  (if (= (preceding-char) ?\t)
	      (progn
		(setq string (make-string (min n (- (current-column) cc)) ?\s))
		(setq n (- n (min n (- (current-column) cc)))))
	    ;; In middle of ctl char => copy that whole char.
	    (backward-char 1)))
      (setq string (concat string
			   (buffer-substring
			    (point)
			    (min (line-end-position)
				 (+ n (point)))))))
    (insert string)))


(defun bodhi-quit-or-leave ()
  "Quit emacs"
  (interactive)
  (kill-buffer))


(defun bodhi-backward-kill-line ()
  "Kill ARG lines backward."
  (interactive)
  (kill-line (- 1)))


(defun bodhi-new-empty-buffer ()
  "Opens a new empty buffer."
  (interactive)
  (let ((buf (generate-new-buffer "untitled")))
    (switch-to-buffer buf)
    (funcall (and initial-major-mode))
    (setq buffer-offer-save t)))


(defun bodhi-search-foward ()
 (interactive)
 (isearch-forward-regexp)
 (bodhi-add-selection-keymap))


(defun bodhi-search-backward ()
 (interactive)
 (isearch-backward-regexp)
 (bodhi-add-selection-keymap))



;; to support inserting space into cua rectanlges
;; while still quitting with space
(defun bodhi-space ()
  (interactive)
  (if cua--rectangle
    (cua-insert-char-rectangle 32) ;SPC
    (keyboard-quit)))


(defun bodhi-enf-of-line ()
  (interactive)
  (if (= (point) (progn (end-of-line) (point)))
     (next-line)))



(defun bodhi-back-to-indentation ()
  (interactive)
  (if (= (point) (progn (back-to-indentation) (point)))
    (beginning-of-line)))


; ---- selection-state ---------------


(defun bodhi-add-selection-keymap ()
  (when (not bodhi-selection-state-map)
  (setq bodhi-selection-state-map (make-sparse-keymap))

  (define-key bodhi-selection-state-map (kbd "l") 'forward-char)
  (define-key bodhi-selection-state-map (kbd "j") 'backward-char)
  (define-key bodhi-selection-state-map (kbd "k") 'next-line)
  (define-key bodhi-selection-state-map (kbd "i") 'previous-line)
  (define-key bodhi-selection-state-map (kbd "$") 'end-of-line)
  (define-key bodhi-selection-state-map (kbd "0") 'beginning-of-line)
  (define-key bodhi-selection-state-map (kbd "à") 'beginning-of-line)
  (define-key bodhi-selection-state-map (kbd "^") 'devil-back-to-indentation)
  (define-key bodhi-selection-state-map (kbd "w") 'forward-word)
  (define-key bodhi-selection-state-map (kbd "b") 'backward-word)

  (define-key bodhi-selection-state-map (kbd "s") 'devil-search-foward)
  (define-key bodhi-selection-state-map (kbd "r") 'devil-search-backward)

  (define-key bodhi-selection-state-map (kbd "c") 'kill-ring-save)  
  (define-key bodhi-selection-state-map (kbd "x") 'kill-region)
  (define-key bodhi-selection-state-map (kbd "d") 'kill-region)

  (define-key bodhi-selection-state-map (kbd "TAB") 'exchange-point-and-mark)
  (define-key bodhi-selection-state-map (kbd "h k") 'describe-key)
  (define-key bodhi-selection-state-map (kbd "h f") 'describe-function)
  (define-key bodhi-selection-state-map (kbd "RET") 'keyboard-quit)
  (define-key bodhi-selection-state-map (kbd "SPC") 'bodhi-space)
  )

  (set-temporary-overlay-map bodhi-selection-state-map t)
)


(defun bodhi-activate-selection-state ()
   (bodhi-add-selection-keymap))

(defun bodhi-deactivate-selection-state ())


(defun bodhi-prepare-for-ibuffer ()
  ; use <space> to go down. i is enough =)
  (define-key ibuffer-mode-map (kbd "i") 'ibuffer-backward-line))


(defun bodhi-prepare-for-isearch ()
  (define-key isearch-mode-map (kbd "C-f") 'isearch-repeat-forward)
  (define-key isearch-mode-map (kbd "C-r") 'isearch-repeat-backward)
  (define-key isearch-mode-map (kbd "C-j") 'isearch-repeat-backward)
)


; ------- hooks --------
; ----------------------

; fix C-i for minibuffer
; provide specific binding for selections

(defun bodhi-prepare-for-minibuffer ()
  (define-key bodhi-normal-state-map (kbd "C-i") 'minibuffer-complete))


(defun bodhi-leave-minibuffer ()
  (define-key bodhi-normal-state-map (kbd "C-i") 'previous-line))


(add-hook 'minibuffer-setup-hook 'bodhi-prepare-for-minibuffer)
(add-hook 'minibuffer-exit-hook  'bodhi-leave-minibuffer)
(add-hook 'activate-mark-hook    'bodhi-activate-selection-state)
(add-hook 'activate-mark-hook    'bodhi-deactivate-selection-state)
(add-hook 'ibuffer-hook     'bodhi-prepare-for-ibuffer)
(add-hook 'isearch-mode-hook 'bodhi-prepare-for-isearch)

; ---- normal-state ------------------


(define-key bodhi-normal-state-map (kbd "M-<SPC>") 'execute-extended-command)

(define-key bodhi-normal-state-map (kbd "C-i") 'previous-line)
(define-key bodhi-normal-state-map (kbd "C-j") 'backward-char)
(define-key bodhi-normal-state-map (kbd "C-l") 'forward-char)
(define-key bodhi-normal-state-map (kbd "C-k") 'next-line)

(define-key bodhi-normal-state-map (kbd "M-l") 'delete-forward-char)
(define-key bodhi-normal-state-map (kbd "M-j") 'delete-backward-char)
(define-key bodhi-normal-state-map (kbd "M-k") 'kill-whole-line)
(define-key bodhi-normal-state-map (kbd "M-i") 'open-line)

(define-key bodhi-normal-state-map (kbd "C-u") 'backward-word)
(define-key bodhi-normal-state-map (kbd "M-u") 'backward-kill-word)
(define-key bodhi-normal-state-map (kbd "C-o") 'forward-word)
(define-key bodhi-normal-state-map (kbd "M-o") 'kill-word)

(define-key bodhi-normal-state-map (kbd "C-q") 'bodhi-quit-or-leave);; quit or leave emacs
(define-key bodhi-normal-state-map (kbd "M-q") 'quoted-insert) ;; eg for $...
(define-key bodhi-normal-state-map (kbd "C-z") 'undo)
(define-key bodhi-normal-state-map (kbd "C-w") 'delete-window)
(define-key bodhi-normal-state-map (kbd "C-t") 'split-window-right)

(define-key bodhi-normal-state-map (kbd "C-x C-s") nil)
(define-key bodhi-normal-state-map (kbd "C-s") 'save-buffer)
(define-key bodhi-normal-state-map (kbd "C-n") 'bodhi-new)

(define-key bodhi-normal-state-map (kbd "C-f") 'isearch-forward)
(define-key bodhi-normal-state-map (kbd "M-f") 'isearch-forward-regexp)
(define-key bodhi-normal-state-map (kbd "C-v") 'cua-paste)

(define-key bodhi-normal-state-map (kbd "$")   'end-of-line)
(define-key bodhi-normal-state-map (kbd "C-$") 'end-of-line)
(define-key bodhi-normal-state-map (kbd "M-$") 'kill-line)

(define-key bodhi-normal-state-map (kbd "C-à") 'beginning-of-line)
(define-key bodhi-normal-state-map (kbd "C-^") 'beginning-of-line)
(define-key bodhi-normal-state-map (kbd "M-à") 'bodhi-backward-kill-line)

(define-key bodhi-normal-state-map (kbd "C-c c") 'bodhi-yank-line)
(define-key bodhi-normal-state-map (kbd "C-x x") 'kill-whole-line)
(define-key bodhi-normal-state-map (kbd "C-x o") 'kill-word)
(define-key bodhi-normal-state-map (kbd "C-x u") 'backward-kill-word)
(define-key bodhi-normal-state-map (kbd "C-x $") 'kill-line)


(define-key bodhi-normal-state-map (kbd "C-<backspace>") 'backward-word)
(define-key bodhi-normal-state-map (kbd "M-<backpsace>") 'backward-kill-word)
(define-key bodhi-normal-state-map (kbd "S-<backspace>") 'forward-word)
(define-key bodhi-normal-state-map (kbd "M-S-<backspace>") 'kill-word)
; ^ s backspace = kill whole line

(define-key bodhi-normal-state-map (kbd "²") 'ibuffer)
(define-key bodhi-normal-state-map (kbd "C-e") 'bodhi-copy-from-above)

(define-minor-mode bodhi-mode 
 "Enlighten your keyboard.
  __ THIS IS A WORK IN PROGRESS. THIS KILLS BABIES __
  Bodhi amends keymap at several places
  - Use C-i C-k to go up down. j and l for right.
    '^' does move and 'alt' does amend (kill).
    Similarly, use u o for words.
  - Basic operators: ^x x cuts line and ^c c copy line.
  - Some more cua : ^f to find, ^v to cua-paste...
  - When region is selected, do not use modifiers to move.
    Use vim like moves, then x to cut region or c to copy
  - Some aliases are defined, like wq to save then exit"
 :lighter bdh
 :global  t
 :keymap bodhi-normal-state-map)


(provide 'bodhi-mode)
