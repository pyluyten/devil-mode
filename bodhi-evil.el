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

(add-to-list 'load-path "./")

(require 'evil)
(require 'bodhi-common)


(define-minor-mode bodhi-evil-mode
 "Enlighten your keyboard"
 :lighter bdh
 :global  t
)


(evil-define-state bodhi
  "Bodhi state.
AKA Cua Paddle state."
  :tag " <b> "
  ;:enable (motion)
  :cursor (bar . 2)
  :message "-- EDIT --"
  :input-method t)


; err, using global mode to trigger our mode does not work.
; This defeats current design.
; I can still override about everything but not sure
; how this will work... well...
(evil-set-initial-state 'emacs-lisp-mode 'bodhi)
(evil-set-initial-state 'org-mode        'bodhi)
(evil-set-initial-state 'cc-mode         'bodhi)
(evil-set-initial-state 'text-mode       'bodhi)




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


(defun bodhi-select-forward-word ()
 (interactive)
 (evil-visual-char)
 (evil-forward-word))

(defun bodhi-select-forward-char ()
 (interactive)
 (evil-visual-char)
 (evil-forward-char))


(defun bodhi-select-backward-char ()
 (interactive)
 (evil-visual-char)
 (evil-backward-char))

(defun bodhi-select-backward-line ()
 (interactive)
 (evil-visual-char)
 (evil-beginning-of-line))

(defun bodhi-select-previous-line ()
 (interactive)
 (evil-visual-char)
 (evil-previous-line))

(defun bodhi-select-next-line ()
  (interactive)
 (evil-visual-char)
 (evil-next-line)
)


(defun bodhi-select-forward-line ()
 (interactive)
 (evil-visual-char)
 (end-of-line))



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



; ------------------ hooks ---------------------------


(defun bodhi-prepare-for-isearch ()
  (define-key isearch-mode-map (kbd "C-f") 'isearch-repeat-forward)
  (define-key isearch-mode-map (kbd "C-r") 'isearch-repeat-backward)
  (define-key isearch-mode-map (kbd "C-j") 'isearch-repeat-backward)
)

(defun bodhi-prepare-for-ibuffer ()
  ; use <space> to go down. i is enough
  (define-key ibuffer-mode-map (kbd "i") 'ibuffer-backward-line))

(defun bodhi-prepare-for-minibuffer ()
  (define-key evil-bodhi-state-map (kbd "C-i") 'minibuffer-complete))


(defun bodhi-leave-minibuffer ()
  (define-key evil-bodhi-state-map (kbd "C-i") 'previous-line))

(defun bodhi-prepare-for-dired ()
  ; use <space> to go down. i is enough
  (define-key dired-mode-map  (kbd "i") 'dired-previous-line))


(add-hook 'minibuffer-setup-hook 'bodhi-prepare-for-minibuffer)
(add-hook 'minibuffer-exit-hook  'bodhi-leave-minibuffer)
(add-hook 'ibuffer-hook          'bodhi-prepare-for-ibuffer)
(add-hook 'isearch-mode-hook     'bodhi-prepare-for-isearch)
(add-hook 'dired-mode-hook       'bodhi-prepare-for-dired)



; ------------------ switches --------------------------


(defun bodhi-quit ()
 (interactive)
 (setq bodhi-quit-map (make-sparse-keymap))
 (define-key bodhi-quit-map (kbd "q") 'evil-normal-state)
 (define-key bodhi-quit-map (kbd "C-q") 'evil-mode)
 (set-temporary-overlay-map bodhi-quit-map ))



(define-key evil-bodhi-state-map (kbd "C-<SPC>") 'evil-visual-char)
(define-key evil-bodhi-state-map (kbd "C-q")   'bodhi-quit)
(define-key evil-normal-state-map (kbd "<RET>")  'evil-bodhi-state)

; ------------------ selections ------------------------

(define-key evil-visual-state-map (kbd "<SPC>") 'evil-bodhi-state)
(define-key evil-visual-state-map (kbd "<ESC>") 'evil-bodhi-state)

(define-key evil-visual-state-map (kbd "l") 'forward-char)
(define-key evil-visual-state-map (kbd "i") 'previous-line)
(define-key evil-visual-state-map (kbd "k") 'next-line)
(define-key evil-visual-state-map (kbd "j") 'backward-char)

(define-key evil-visual-state-map (kbd "$") 'end-of-line)
(define-key evil-visual-state-map (kbd "0") 'beginning-of-line)
(define-key evil-visual-state-map (kbd "à") 'beginning-of-line) ; azerty for 0
(define-key evil-visual-state-map (kbd "^") 'evil-first-non-blank)
(define-key evil-visual-state-map (kbd "o") 'forward-word)
(define-key evil-visual-state-map (kbd "w") 'forward-word)
(define-key evil-visual-state-map (kbd "u") 'backward-word)
(define-key evil-visual-state-map (kbd "b") 'backward-word)

(define-key evil-visual-state-map (kbd "s") 'bodhi-search-foward)
(define-key evil-visual-state-map (kbd "r") 'bodhi-search-backward)

(define-key evil-visual-state-map (kbd "c") 'kill-ring-save)
(define-key evil-visual-state-map (kbd "x") 'kill-region)
(define-key evil-visual-state-map (kbd "d") 'kill-region)

(define-key evil-visual-state-map (kbd "TAB") 'exchange-point-and-mark)
(define-key evil-visual-state-map (kbd "h k") 'describe-key)
(define-key evil-visual-state-map (kbd "h f") 'describe-function)



; selecting from bodhi mode

(define-key evil-bodhi-state-map (kbd "C-S-K")        'bodhi-select-next-line)
(define-key evil-bodhi-state-map (kbd "C-S-J")        'bodhi-select-backward-char)
; below work only once since tab does exchange point & mark. Might be fine enough.
(define-key evil-bodhi-state-map (kbd "C-S-I")        'bodhi-select-previous-line)
(define-key evil-bodhi-state-map (kbd "C-S-O")        'bodhi-select-forward-word)
(define-key evil-bodhi-state-map (kbd "C-S-L")        'bodhi-select-forward-char)
(define-key evil-bodhi-state-map (kbd "S-<end>")    'bodhi-select-forward-line)
(define-key evil-bodhi-state-map (kbd "S-<orig>") 'bodhi-select-backward-line)

; S-$ does not work without layout support

(define-key evil-bodhi-state-map (kbd "C-<SPC>")    'evil-visual-char)


; ------------------ insert     -------------------------

(define-key evil-bodhi-state-map (kbd "M-<SPC>") 'execute-extended-command)

(define-key evil-bodhi-state-map (kbd "C-i") 'evil-previous-line)
(define-key evil-bodhi-state-map (kbd "C-j") 'evil-backward-char)
(define-key evil-bodhi-state-map (kbd "C-k") 'evil-next-line)
(define-key evil-bodhi-state-map (kbd "C-l") 'forward-char)


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
 
;(define-key evil-bodhi-state-map (kbd "C-q") 'keyboard-quit)
(define-key evil-bodhi-state-map (kbd "M-q") 'quoted-insert) ;; eg for $...
(define-key evil-bodhi-state-map (kbd "C-z") 'undo)
(define-key evil-bodhi-state-map (kbd "C-w") 'delete-window)
(define-key evil-bodhi-state-map (kbd "C-t") 'split-window-right)

(define-key evil-bodhi-state-map (kbd "C-x C-s") nil)
(define-key evil-bodhi-state-map (kbd "C-s") 'save-buffer)
(define-key evil-bodhi-state-map (kbd "C-n") 'bodhi-new-empty-buffer)

; only find is usable. Other ^f keys are there to *document*
(define-key evil-bodhi-state-map (kbd "C-f") 'bodhi-find-prompt)
(global-set-key (kbd "<C-M-f>") nil)
(global-set-key (kbd "<C-M-r>") nil)
(define-key evil-bodhi-state-map (kbd "<C-f f>") 'isearch-forward)
(define-key evil-bodhi-state-map (kbd "<C-f r>") 'isearch-backward)
(define-key evil-bodhi-state-map (kbd "<C-f i>" ) 'nonincremental-search-backward)
(define-key evil-bodhi-state-map (kbd "<C-f k>")  'nonincremental-search-forward)
(define-key evil-bodhi-state-map (kbd "<C-f j>")  'isearch-forward-regexp)
(define-key evil-bodhi-state-map (kbd "<C-f l>")  'isearch-backward-regexp)
(define-key evil-bodhi-state-map (kbd "<C-f ?>")  'bodhi-prompt-find)


(define-key evil-bodhi-state-map (kbd "M-f") 'regexp-builder)
(define-key evil-bodhi-state-map (kbd "C-r") 'bodhi-replace)
(define-key evil-bodhi-state-map (kbd "C-v") 'evil-paste-after)

;  ---------- additional edition features -------------------

(define-key evil-bodhi-state-map (kbd "C-e") 'evil-copy-from-above)
(define-key evil-bodhi-state-map (kbd "C-y") 'evil-copy-from-below)
(define-key evil-bodhi-state-map (kbd "M-m") 'newline-and-indent)


; ----------- others ------------------------------------------

(define-key evil-bodhi-state-map (kbd "²") 'ibuffer)
(define-key evil-bodhi-state-map (kbd "<backtab>") 'next-buffer)
(define-key evil-bodhi-state-map (kbd "C-<prior>") 'previous-buffer) ;; page down
(define-key evil-bodhi-state-map (kbd "C-<next>") 'previous-buffer) ;; page up


; "global"l
(define-prefix-command 'g-map)
(define-key evil-bodhi-state-map (kbd "C-g") 'g-map)
(define-key evil-bodhi-state-map (kbd "C-g i") 'beginning-of-buffer)
(define-key evil-bodhi-state-map (kbd "C-g k") 'end-of-buffer)
(define-key evil-bodhi-state-map (kbd "C-g j") 'next-buffer)
(define-key evil-bodhi-state-map (kbd "C-g l") 'other-window)





(provide 'bodhi-evil)
