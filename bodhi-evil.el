; bodhi-evil is licensed under GPLv2 +, that is, GPL v2 or further at your convenience.
;
;
; -------------------- BODHI EVIL -----------------------------
;
;  Implement
;  - evil-bodhi-state
;    - paddle, extended paddle + cua paddle
;    - prompts (^f, ^r...)
;    - op/motion shortcuts
;  - [ ] evil-selection-state (close to visual state)
;  - [ ] evil-rectangle-state (close to visual block)
;  - more aliases might come. But since we implement on top of evil...
;
;
;  Principle
;  we define a global minor mode and associate every buffer with that
;  minor mode with bodhi.
;  one of the reasons is evil provides a nice infra.
;  for selections, we don't need to handle the keymaps stack ouserlves.
;

(require 'evil)


(define-minor-mode bodhi-evil-mode
 "Enlighten your keyboard"
 :lighter bdh
 :global  t
)


(evil-define-state bodhi
  "Bodhi state.
AKA Cua Paddle state."
  :tag " <B> "
  ;:enable (motion)
  :cursor (bar . 2)
  :message "-- EDIT --"
  :input-method t)


; err, using global mode to trigger our mode does not work.
; This defeats current design.
; I can still override about everything but not sure
; how this will work... well...
(evil-set-initial-state 'emacs-lisp-mode 'bodhi)



; ------------------ some commands i need -------------

(defun bodhi-backward-kill-line ()
  "Kill ARG lines backward."
  (interactive)
  (kill-line (- 0)))


(defun bodhi-new-empty-buffer ()
  "Opens a new empty buffer."
  (interactive)
  (let ((buf (generate-new-buffer "untitled")))
    (switch-to-buffer buf)
    (funcall (and initial-major-mode))
    (setq buffer-offer-save t)))


(defun bodhi-prompt-find ()
 (interactive)
 (print "i=search bacwkard, k=search forward, j=regexp backward, l=regex forward")
 (bodhi-find)
)


(defun bodhi-find ()
 (interactive)
  (setq bodhi-find-map (make-sparse-keymap))
  (define-key bodhi-find-map (kbd "f") 'isearch-forward)

  (define-key bodhi-find-map (kbd "i") 'isearch-backward)
  (define-key bodhi-find-map (kbd "k") 'isearch-forward)
  (define-key bodhi-find-map (kbd "j") 'isearch-forward-regexp)
  (define-key bodhi-find-map (kbd "l") 'isearch-backward-regexp)
  (define-key bodhi-find-map (kbd "?") 'bodhi-prompt-find)

  (set-temporary-overlay-map bodhi-find-map t)
)


(defun bodhi-prompt-replace ()
  (interactive)
  (print "i=backward, k=forward, j=reg backward, k=reg forward")
  (bodhi-replace)
)


(defun bodhi-replace ()
 (interactive)
  (setq bodhi-replace-map (make-sparse-keymap))
  (define-key bodhi-replace-map (kbd "r") 'query-replace-regexp)

  (define-key bodhi-replace-map (kbd "i") 'query-replace)
  (define-key bodhi-replace-map (kbd "k") 'query-replace-regexp)
  (define-key bodhi-replace-map (kbd "j") 'replace-string)
  (define-key bodhi-replace-map (kbd "l") 'replace-regexp)
  (define-key bodhi-replace-map (kbd "?") 'bodhi-prompt-replace)

  (set-temporary-overlay-map bodhi-replace-map t)
)


; ------------------ selections ------------------------


; ------------------ insert     -------------------------

(define-key evil-bodhi-state-map (kbd "M-<SPC>") 'execute-extended-command)

(define-key evil-bodhi-state-map (kbd "C-i") 'evil-previous-line)
(define-key evil-bodhi-state-map (kbd "C-j") 'evil-backward-char)
(define-key evil-bodhi-state-map (kbd "C-k") 'evil-next-line)
(define-key evil-bodhi-state-map (kbd "C-l") 'evil-forward-char)


(define-key evil-bodhi-state-map (kbd "M-l") 'delete-forward-char)
(define-key evil-bodhi-state-map (kbd "M-j") 'delete-backward-char)
(define-key evil-bodhi-state-map (kbd "M-k") 'kill-whole-line)
(define-key evil-bodhi-state-map (kbd "M-i") 'open-line)

(define-key evil-bodhi-state-map (kbd "C-u") 'backward-word)
(define-key evil-bodhi-state-map (kbd "M-u") 'backward-kill-word)
(define-key evil-bodhi-state-map (kbd "C-o") 'forward-word)
(define-key evil-bodhi-state-map (kbd "M-o") 'kill-word)

(define-key evil-bodhi-state-map (kbd "$")   'end-of-line)
(define-key evil-bodhi-state-map (kbd "C-$") 'end-of-line)
(define-key evil-bodhi-state-map (kbd "M-$") 'kill-line)

(define-key evil-bodhi-state-map (kbd "C-à") 'beginning-of-line)
(define-key evil-bodhi-state-map (kbd "C-^") 'beginning-of-line)
(define-key evil-bodhi-state-map (kbd "M-à") 'bodhi-backward-kill-line)


(define-key evil-bodhi-state-map (kbd "C-<backspace>") 'backward-word)
(define-key evil-bodhi-state-map (kbd "M-<backpsace>") 'backward-kill-word)
(define-key evil-bodhi-state-map (kbd "S-<backspace>") 'forward-word)
(define-key evil-bodhi-state-map (kbd "M-S-<backspace>") 'kill-word)
; ^ s backspace = kill whole line


;; somewhat cua : operator -> motion. We don't want to override everything.
;; we would somewhat need some prefix...ù*

(define-key evil-bodhi-state-map (kbd "C-c c") 'evil-yank-line)
(define-key evil-bodhi-state-map (kbd "C-x x") 'kill-whole-line)
(define-key evil-bodhi-state-map (kbd "C-x o") 'kill-word)
(define-key evil-bodhi-state-map (kbd "C-x u") 'backward-kill-word)
(define-key evil-bodhi-state-map (kbd "C-x $") 'kill-line)

;; cua + nilliy std keys.
 
(define-key evil-bodhi-state-map (kbd "C-q") 'keyboard-quit)
(define-key evil-bodhi-state-map (kbd "M-q") 'quoted-insert) ;; eg for $...
(define-key evil-bodhi-state-map (kbd "C-z") 'undo)
(define-key evil-bodhi-state-map (kbd "C-w") 'delete-window)
(define-key evil-bodhi-state-map (kbd "C-t") 'split-window-right)

(define-key evil-bodhi-state-map (kbd "C-x C-s") nil)
(define-key evil-bodhi-state-map (kbd "C-s") 'save-buffer)
(define-key evil-bodhi-state-map (kbd "C-n") 'bodhi-new-empty-buffer)

(define-key evil-bodhi-state-map (kbd "C-f") 'bodhi-find)
(define-key evil-bodhi-state-map (kbd "M-f") 'regexp-builder)
(define-key evil-bodhi-state-map (kbd "C-r") 'bodhi-replac*e)
(define-key evil-bodhi-state-map (kbd "C-v") 'evil-paste-after)

;  ---------- additional edition features -------------------

(define-key evil-bodhi-state-map (kbd "C-e") 'evil-copy-from-above)
(define-key evil-bodhi-state-map (kbd "C-y") 'evil-copy-from-below)
(define-key evil-bodhi-state-map (kbd "M-m") 'newline-and-indent)


; ----------- others ------------------------------------------

(define-key evil-bodhi-state-map (kbd "²") 'ibuffer)
(define-key evil-bodhi-state-map (kbd "<backtab>") 'next-buffer)





(provide 'bodhi-evil)
