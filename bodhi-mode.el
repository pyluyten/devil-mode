;; todo : document a bit --> info
;;
;;    (require 'bodhi) -> global minor mode
;;    This conflicts with ^o open file.
;;    This conflicts with ^c c to capture.
;;    TAB is not available. Well it goes previous line.
;;
;;    TODO : org-mode. EXCLUDE : maggit, ...
;;    TODO : mode-dependant cursor
;;    MAYBE: ^g for "global" (buffer,...)
;;
;;    Remember, C-i=TAB, C-m=RET, avoid "?"


(require 'cua-base)
(require 'rect)

(require 'bodhi-common)

; ---- vars & assignements -----------

(setq cursor-type 'bar)
(defvar bodhi-selection-state-map nil "Keymap for bodhi selection state")
(defvar bodhi-normal-state-map nil "Keymap for bodhi normal state")
(setq bodhi-normal-state-map (make-sparse-keymap))



; this one does not make sens elsewhere...

(defalias 'bdh     'bodhi-mode)



; TODO : modeline.


; ---- commands ----------------------


(defun bodhi-quit-or-leave ()
  "Quit emacs"
  (interactive)
  (kill-buffer))

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


(defun bodhi-join-next-line () (interactive) (join-line 1))


(defun bodhi-function-editor ()
  (interactive)
  (setq bodhi-editor-map (make-sparse-keymap))

  (define-key bodhi-editor-map (kbd "j") 'bodhi-join-next-line)
  (define-key bodhi-editor-map (kbd "J") 'join-line)

  (set-temporary-overlay-map bodhi-editor-map t)
)




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
  (define-key bodhi-selection-state-map (kbd "^") 'bodhi-back-to-indentation)
  (define-key bodhi-selection-state-map (kbd "w") 'forward-word)
  (define-key bodhi-selection-state-map (kbd "b") 'backward-word)

  (define-key bodhi-selection-state-map (kbd "s") 'bodhi-search-foward)
  (define-key bodhi-selection-state-map (kbd "r") 'bodhi-search-backward)

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
  ; use <space> to go down. i is enough
  (define-key ibuffer-mode-map (kbd "i") 'ibuffer-backward-line))


(defun bodhi-prepare-for-dired ()
  ; use <space> to go down. i is enough
  (define-key dired-mode-map  (kbd "i") 'dired-previous-line))


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
(add-hook 'ibuffer-hook          'bodhi-prepare-for-ibuffer)
(add-hook 'isearch-mode-hook     'bodhi-prepare-for-isearch)
(add-hook 'dired-mode-hook       'bodhi-prepare-for-dired)

; ---- normal-state ------------------

; essential navigation and commands
(define-key bodhi-normal-state-map (kbd "M-<SPC>") 'execute-extended-command)
(define-key bodhi-normal-state-map (kbd "C-:") 'execute-extended-command)

(define-key bodhi-normal-state-map (kbd "M-i") 'previous-line)
(define-key bodhi-normal-state-map (kbd "M-j") 'backward-char)
(define-key bodhi-normal-state-map (kbd "M-l") 'forward-char)
(define-key bodhi-normal-state-map (kbd "M-k") 'next-line)

(define-key bodhi-normal-state-map (kbd "C-l") 'delete-forward-char)
(define-key bodhi-normal-state-map (kbd "C-j") 'delete-backward-char)
(define-key bodhi-normal-state-map (kbd "C-k") 'kill-whole-line)
(define-key bodhi-normal-state-map (kbd "C-i") 'open-line)

(define-key bodhi-normal-state-map (kbd "M-u") 'backward-word)
(define-key bodhi-normal-state-map (kbd "C-u") 'backward-kill-word)
(define-key bodhi-normal-state-map (kbd "M-o") 'forward-word)
(define-key bodhi-normal-state-map (kbd "C-o") 'kill-word)

(define-key bodhi-normal-state-map (kbd "$")   'end-of-line)
(define-key bodhi-normal-state-map (kbd "M-$") 'end-of-line)
(define-key bodhi-normal-state-map (kbd "C-$") 'kill-line)

(define-key bodhi-normal-state-map (kbd "M-à") 'beginning-of-line)
(define-key bodhi-normal-state-map (kbd "M-^") 'beginning-of-line)
(define-key bodhi-normal-state-map (kbd "C-à") 'bodhi-backward-kill-line)


(define-key bodhi-normal-state-map (kbd "C-<backspace>") 'backward-word)
(define-key bodhi-normal-state-map (kbd "M-<backpsace>") 'backward-kill-word)
(define-key bodhi-normal-state-map (kbd "S-<backspace>") 'forward-word)
(define-key bodhi-normal-state-map (kbd "M-S-<backspace>") 'kill-word)
; ^ s backspace = kill whole line


;; somewhat cua : operator -> motion 

(define-key bodhi-normal-state-map (kbd "C-c c") 'bodhi-copy-line)
(define-key bodhi-normal-state-map (kbd "C-x x") 'kill-whole-line)

;; cua + nilliy std keys.

(define-key bodhi-normal-state-map (kbd "C-q") 'keyboard-quit)
(define-key bodhi-normal-state-map (kbd "M-q") 'quoted-insert) ;; eg for $...
(define-key bodhi-normal-state-map (kbd "C-z") 'undo)
(define-key bodhi-normal-state-map (kbd "C-w") 'bodhi-close-tab)
(define-key bodhi-normal-state-map (kbd "C-t") 'split-window-right)

(define-key bodhi-normal-state-map (kbd "C-x C-s") nil)
(define-key bodhi-normal-state-map (kbd "C-s") 'save-buffer)
(define-key bodhi-normal-state-map (kbd "C-n") 'bodhi-new-empty-buffer)

(define-key bodhi-normal-state-map (kbd "C-f") 'bodhi-find-prompt)
(define-key bodhi-normal-state-map (kbd "M-f") 'tmm-menubar)
(define-key bodhi-normal-state-map (kbd "C-r") 'bodhi-replace-prompt)
(define-key bodhi-normal-state-map (kbd "C-g") 'bodhi-global-prompt)


(define-key bodhi-normal-state-map (kbd "C-v") 'cua-paste)


; ----------- function keys ----------------------------------
; F1 , F2 , F3 macro, F4 macro stop/exe

; F5 or , = editor
(define-key bodhi-normal-state-map (kbd "M-e")  'bodhi-function-editor)
(define-key bodhi-normal-state-map (kbd "<F5>") 'bodhi-function-editor)


;  ---------- additional edition features -------------------

(define-key bodhi-normal-state-map (kbd "C-e") 'bodhi-copy-from-above)

; i want to switch, but this requires some emulation before
;(define-key bodhi-normal-state-map (kbd "C-m") 'newline-and-indent)
;(define-key bodhi-normal-state-map (kbd "M-m") 'RET...)

; ----------- others ------------------------------------------

(define-key bodhi-normal-state-map (kbd "²") 'ibuffer)
(define-key bodhi-normal-state-map (kbd "<backtab>") 'next-buffer)





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
