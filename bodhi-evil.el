; bodhi-evil is licensed under GPLv2 +, that is, GPL v2 or further at your convenience.
;
;
; -------------------- BODHI EVIL -----------------------------
;
;  Implement
;  - [-] evil-bodhi-state
;    - [x] paddle, extended paddle + cua paddle
;    - [-] prompts (^f, ^r...)
;    - [-] op/motion shortcuts
;  - [x] amend evil-selection-state to be consitent
;  - [ ] evil-rectangle-state or visual. Or make cua-rectangle work.
;        well, cua-rectangle is now usable
;        don't know about 24.4 rectangles
;  - [x] amend evil-normal-state to be consistent
;  - [ ] more aliases might come. But since we implement on top of evil...
;
;
;  Principle
;    we define a global minor mode and associate every buffer with that
;    minor mode with bodhi.
;    one of the reasons is evil provides a nice infra.
;    for selections, we don't need to handle the keymaps stack ouserlves.
;


(add-to-list 'load-path "./")

(require 'evil)
(require 'bodhi-common)


(define-minor-mode bodhi-evil-mode
 "Enlighten your keyboard"
 :lighter bdh
 :global  t
)



; do not declare states. mess up evil.
(setq evil-normal-state-tag "^")
(setq evil-insert-state-tag "!")
(setq evil-visual-state-tag "<>")
(setq evil-default-state 'insert) ; yup. this makes sense, really. Normal is just there for tired fingers on the evening =)


;(evil-define-state bodhi    ;; nah nah seriously, this works but i just want to have fun.
;  "Bodhi state.
;AKA Cua Paddle state."
;  :tag " <b> "
;  ;:enable (motion)
;  :cursor (bar . 2)
;  :message "- EDIT -"
;  :input-method t)
;(setq evil-default-state 'bodhi)


; ------------------ some commands i need -------------
; -- - only commands depending on evil here -----------


(defun bodhi-select-forward-word ()
  "Select forward word."
 (interactive)
 (evil-visual-char)
 (forward-word))


(defun bodhi-select-backward-word ()
  "Select backward word."
 (interactive)
 (evil-visual-char)
 (backward-word))


(defun bodhi-select-forward-char ()
  "Select forward char."
 (interactive)
 (evil-visual-char)
 (evil-forward-char))


(defun bodhi-select-backward-char ()
  "Select backward char."
 (interactive)
 (evil-visual-char)
 (evil-backward-char))

(defun bodhi-select-backward-line ()
  "Select backward line."
 (interactive)
 (evil-visual-char)
 (evil-beginning-of-line))

(defun bodhi-select-previous-line ()
  "Select previous line."
 (interactive)
 (evil-visual-char)
 (evil-previous-line))

(defun bodhi-select-next-line ()
  "Select next line."
 (interactive)
 (evil-visual-char)
 (evil-next-line)
)


(defun bodhi-select-forward-line ()
  "Select forward line."
 (interactive)
 (evil-visual-char)
 (end-of-line))


; commands to switch to normal-god-super-ultra mode from bodhi-state
(defun bodhi-normal-state-after ()
  (interactive)
  (evil-normal-state)
  (evil-forward-char))


(defun bodhi-normal-state-after-line ()
  (interactive)
  (evil-normal-state)
  (evil-end-of-line))


(defun bodhi-normal-state-before-line ()
  (interactive)
  (evil-normal-state)
  (evil-beginning-of-line))


(defun bodhi-normal-state-previous-line ()
  (interactive)
  (evil-normal-state)
  (evil-previous-line))


(defun bodhi-normal-state-next-line ()
  (interactive)
  (evil-normal-state)
  (evil-next-line))


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
  "Restore tab for completion."
  (define-key evil-insert-state-map (kbd "C-i") 'minibuffer-complete))


(defun bodhi-leave-minibuffer ()
  "Restore tab for previous."
  (define-key evil-insert-state-map (kbd "C-i") 'previous-line))

(defun bodhi-prepare-for-dired ()
  ; use <space> to go down. i is enough
  (define-key dired-mode-map  (kbd "i") 'dired-previous-line))


(add-hook 'minibuffer-setup-hook 'bodhi-prepare-for-minibuffer)
(add-hook 'minibuffer-exit-hook  'bodhi-leave-minibuffer)
(add-hook 'ibuffer-hook          'bodhi-prepare-for-ibuffer)
(add-hook 'isearch-mode-hook     'bodhi-prepare-for-isearch)
(add-hook 'dired-mode-hook       'bodhi-prepare-for-dired)


; ------------------ switches from bodhi-state ---------------------

; we rely on visual char for char selection,
; & cua rectangles for blocks. evil-block and lines are not used.
; yet to be studied is 24.4 rectangles.

(define-key evil-insert-state-map (kbd "C-<SPC>") 'evil-visual-char)
(define-key evil-insert-state-map (kbd "C-<RET>")  'cua-rectangle-set-mark) ;; fixme of course. Cannot work.

; switch to normal-state
(define-key evil-insert-state-map (kbd "C-M-l") 'bodhi-normal-state-after)
(define-key evil-insert-state-map (kbd "C-M-j") 'evil-normal-state)
(define-key evil-insert-state-map (kbd "C-M-i") 'bodhi-normal-state-previous-line)
(define-key evil-insert-state-map (kbd "C-M-k") 'bodhi-normal-state-next-line)
(define-key evil-insert-state-map (kbd "C-M-u") 'bodhi-normal-state-before-line)
(define-key evil-insert-state-map (kbd "C-M-o") 'bodhi-normal-state-after-line)


; ------------------ normal-state inspired from god mode   ----
; keybinding should stay close to insert mode

(define-key evil-normal-state-map (kbd "<RET>")  'evil-insert-state)


; paddle & extended paddle
(define-key evil-normal-state-map (kbd "i") 'evil-previous-line)
(define-key evil-normal-state-map (kbd "j") 'evil-backward-char)
(define-key evil-normal-state-map (kbd "k") 'evil-next-line)
(define-key evil-normal-state-map (kbd "l") 'evil-forward-char)

(define-key evil-normal-state-map (kbd "u") 'backward-word)
(define-key evil-normal-state-map (kbd "o") 'forward-word)
(define-key evil-normal-state-map (kbd "$") 'evil-end-of-line)
(define-key evil-normal-state-map (kbd "^") 'evil-beginning-of-line)
(define-key evil-normal-state-map (kbd "à") 'evil-beginning-of-line)

; switches
(define-key evil-normal-state-map (kbd "M-i") 'evil-open-above)
(define-key evil-normal-state-map (kbd "M-j") 'evil-insert)
(define-key evil-normal-state-map (kbd "M-k") 'evil-open-below)
(define-key evil-normal-state-map (kbd "M-l") 'evil-append)
(define-key evil-normal-state-map (kbd "M-u") 'evil-insert-line)
(define-key evil-normal-state-map (kbd "M-o") 'evil-append-line)


; swap keys for paddle
(define-key evil-normal-state-map (kbd "i") 'evil-previous-line)
(define-key evil-normal-state-map (kbd "I") 'evil-window-top)
(define-key evil-normal-state-map (kbd "j") 'evil-backward-char)
(define-key evil-normal-state-map (kbd "k") 'evil-next-line)


;;  ok now do real stuff
(define-key evil-normal-state-map (kbd "v") 'evil-paste-after)
(define-key evil-normal-state-map (kbd "f") 'bodhi-find-prompt)
(define-key evil-normal-state-map (kbd "r") 'bodhi-replace-prompt)
(define-key evil-normal-state-map (kbd "s") 'save-buffer)
(define-key evil-normal-state-map (kbd "g") 'bodhi-global-prompt)
(define-key evil-normal-state-map (kbd "z") 'undo-tree-undo)
(define-key evil-normal-state-map (kbd "w") 'bodhi-close-tab)


(define-key evil-normal-state-map (kbd "x") 'Control-X-prefix)

; ------------------ selections ------------------------

; actually this depends on *which* visual state.
(define-key evil-visual-state-map (kbd "C-<SPC>") 'evil-insert-state)
(define-key evil-visual-state-map (kbd "<ESC>") 'evil-insert-state)

(define-key evil-visual-state-map (kbd "l") 'forward-char)
(define-key evil-visual-state-map (kbd "i") 'previous-line)
(define-key evil-visual-state-map (kbd "k") 'next-line)
(define-key evil-visual-state-map (kbd "j") 'backward-char)

(define-key evil-visual-state-map (kbd "$") 'end-of-line)
(define-key evil-visual-state-map (kbd "0") 'beginning-of-line)
(define-key evil-visual-state-map (kbd "à") 'beginning-of-line) ; azerty for 0
(define-key evil-visual-state-map (kbd "^") 'evil-first-non-blank)
(define-key evil-visual-state-map (kbd "o") 'forward-word)
(define-key evil-visual-state-map (kbd "u") 'backward-word)
(define-key evil-visual-state-map (kbd "b") 'backward-word)

(define-key evil-visual-state-map (kbd "s") 'bodhi-search-foward)
(define-key evil-visual-state-map (kbd "r") 'bodhi-search-backward)

(define-key evil-visual-state-map (kbd "c") 'kill-ring-save)
(define-key evil-visual-state-map (kbd "x") 'kill-region) ; cannot Control-X-prefix.
(define-key evil-visual-state-map (kbd "d") 'kill-region)
(define-key evil-visual-state-map (kbd "<backspace>") 'kill-region)

(define-key evil-visual-state-map (kbd "TAB") 'exchange-point-and-mark)
(define-key evil-visual-state-map (kbd "h k") 'describe-key)
(define-key evil-visual-state-map (kbd "h f") 'describe-function)


(define-key evil-visual-state-map (kbd "f") 'bodhi-find-prompt)
(define-key evil-visual-state-map (kbd "r") 'bodhi-replace-prompt)
(define-key evil-visual-state-map (kbd "s") 'save-buffer)
(define-key evil-visual-state-map (kbd "g") 'bodhi-global-prompt)
;(define-key evil-visual-state-map (kbd "z") 'undo-tree-undo)
(define-key evil-visual-state-map (kbd "w") 'bodhi-close-tab)


; selecting from bodhi mode

(define-key evil-insert-state-map (kbd "M-K")        'bodhi-select-next-line)
(define-key evil-insert-state-map (kbd "M-J")        'bodhi-select-backward-char)
; below work only once since tab does exchange point & mark. Might be fine enough.
(define-key evil-insert-state-map (kbd "M-I")        'bodhi-select-previous-line)
(define-key evil-insert-state-map (kbd "M-O")        'bodhi-select-forward-word)
(define-key evil-insert-state-map (kbd "M-U")        'bodhi-select-backward-word)
(define-key evil-insert-state-map (kbd "M-L")        'bodhi-select-forward-char)

(define-key evil-insert-state-map (kbd "S-<end>")    'bodhi-select-forward-line)
(define-key evil-insert-state-map (kbd "S-<orig>") 'bodhi-select-backward-line)

; S-$ does not work without layout support

(define-key evil-insert-state-map (kbd "C-<SPC>")    'evil-visual-char)


; ------------------ insert     -------------------------

; M- is goto. M space is go to space =)
(define-key evil-insert-state-map (kbd "M-<SPC>") 'execute-extended-command)


; paddle

(define-key evil-insert-state-map (kbd "M-i") 'evil-previous-line)
(define-key evil-insert-state-map (kbd "M-j") 'evil-backward-char)
(define-key evil-insert-state-map (kbd "M-k") 'evil-next-line)
(define-key evil-insert-state-map (kbd "M-l") 'forward-char)

(define-key evil-insert-state-map (kbd "C-l") 'delete-forward-char)
(define-key evil-insert-state-map (kbd "C-j") 'delete-backward-char)
(define-key evil-insert-state-map (kbd "C-k") 'kill-whole-line)
(define-key evil-insert-state-map (kbd "C-i") 'open-line)

; extended paddle

(define-key evil-insert-state-map (kbd "M-u") 'backward-word)
(define-key evil-insert-state-map (kbd "M-o") 'forward-word)
(define-key evil-insert-state-map (kbd "M-$") 'end-of-line)
(define-key evil-insert-state-map (kbd "M-à") 'beginning-of-line)
(define-key evil-insert-state-map (kbd "M-^") 'beginning-of-line)

(define-key evil-insert-state-map (kbd "C-u") 'backward-kill-word)
(define-key evil-insert-state-map (kbd "C-o") 'kill-word)
(define-key evil-insert-state-map (kbd "$")   'end-of-line)
(define-key evil-insert-state-map (kbd "C-$") 'kill-line)
(define-key evil-insert-state-map (kbd "C-à") 'bodhi-backward-kill-line)

; some alternatives to handle most current deletion

(define-key evil-insert-state-map (kbd "C-<backspace>") 'backward-kill-word)
(define-key evil-insert-state-map (kbd "C-S-<backspace>") 'kill-whole-line)
(define-key evil-insert-state-map (kbd "C-d") 'delete-char)
(define-key evil-insert-state-map (kbd "M-d") 'kill-word)

(define-key evil-insert-state-map (kbd "M-<backpsace>") 'kill-word) ; really buggy now
(define-key evil-insert-state-map (kbd "S-<backspace>") nil) ; select some word? innerword?
(define-key evil-insert-state-map (kbd "M-S-<backspace>") nil) ;

;; somewhat cua : operator -> motion. We don't want to override everything.
;; we would somewhat need some prefix...ù*

(define-key evil-insert-state-map (kbd "C-c c") 'evil-yank-line)
(define-key evil-insert-state-map (kbd "C-c $") 'bodhi-yank-end-of-line)

(define-key evil-insert-state-map (kbd "C-x x") 'kill-whole-line)
(define-key evil-insert-state-map (kbd "C-x o") 'kill-word)
(define-key evil-insert-state-map (kbd "C-x u") 'backward-kill-word)
(define-key evil-insert-state-map (kbd "C-x $") 'kill-line)

;; cua + nilliy std keys.
 
(define-key evil-insert-state-map (kbd "C-q") 'keyboard-quit)
(define-key evil-insert-state-map (kbd "M-q") 'quoted-insert) ;; eg for $...
(define-key evil-insert-state-map (kbd "C-z") 'undo)
(define-key evil-insert-state-map (kbd "C-w") 'bodhi-close-tab)
(define-key evil-insert-state-map (kbd "C-t") 'split-window-right)

(define-key evil-insert-state-map (kbd "C-x C-s") nil)
(define-key evil-insert-state-map (kbd "C-s") 'save-buffer)
(define-key evil-insert-state-map (kbd "C-n") 'bodhi-new-empty-buffer)

; only find is usable. Other ^f keys are there to *document*
(define-key evil-insert-state-map (kbd "C-f") 'bodhi-find-prompt)
(global-set-key (kbd "<C-M-f>") nil)
(global-set-key (kbd "<C-M-r>") nil)
(define-key evil-insert-state-map (kbd "<C-f f>") 'isearch-forward)
(define-key evil-insert-state-map (kbd "<C-f r>") 'isearch-backward)
(define-key evil-insert-state-map (kbd "<C-f i>" ) 'nonincremental-search-backward)
(define-key evil-insert-state-map (kbd "<C-f k>")  'nonincremental-search-forward)
(define-key evil-insert-state-map (kbd "<C-f j>")  'isearch-forward-regexp)
(define-key evil-insert-state-map (kbd "<C-f l>")  'isearch-backward-regexp)
(define-key evil-insert-state-map (kbd "<C-f ?>")  'bodhi-prompt-find)

(define-key evil-insert-state-map (kbd "C-r") 'bodhi-replace-prompt)


(define-key evil-insert-state-map (kbd "C-v") 'yank)

; alt
(define-key evil-insert-state-map (kbd "M-f") 'tmm-menubar)

;  ---------- additional edition features -------------------

(define-key evil-insert-state-map (kbd "C-e") 'evil-copy-from-above)
(define-key evil-insert-state-map (kbd "C-y") 'evil-copy-from-below)

(define-key evil-insert-state-map (kbd "M-m") 'newline)
(define-key evil-insert-state-map (kbd "C-m") 'newline-and-indent)

; ----------- others ------------------------------------------

(define-key evil-insert-state-map (kbd "²") 'ibuffer)
(define-key evil-insert-state-map (kbd "<backtab>") 'next-buffer)
(define-key evil-insert-state-map (kbd "C-<prior>") 'previous-buffer) ;; page down
(define-key evil-insert-state-map (kbd "C-<next>") 'previous-buffer) ;; page up


; "global"l
(define-key evil-insert-state-map (kbd "C-g") 'bodhi-global-prompt)




(provide 'bodhi-evil)
