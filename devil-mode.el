;;          KEYMAP
;; --------------------------------------------
(defvar devil-mode-map nil "Keymap for devil-mode")


(defun devil-add-selection-keymap ()
  (when (not devil-mode-map)
  (setq devil-mode-map (make-sparse-keymap))

  ;------------------ moves -------------------------
  (define-key devil-mode-map (kbd "l") 'forward-char)
  (define-key devil-mode-map (kbd "j") 'backward-char)
  (define-key devil-mode-map (kbd "k") 'next-line)
  (define-key devil-mode-map (kbd "i") 'previous-line)
  (define-key devil-mode-map (kbd "$") 'end-of-line)
  (define-key devil-mode-map (kbd "a") 'beginning-of-line)
  (define-key devil-mode-map (kbd "0") 'beginning-of-line)
  (define-key devil-mode-map (kbd "^") 'back-to-indentation)
  (define-key devil-mode-map (kbd "w") 'forward-word)
  (define-key devil-mode-map (kbd "b") 'backward-word)
  (define-key devil-mode-map (kbd "z") 'zap-to-char)

  ;------------------------ more moves! ----------------
  (define-key devil-mode-map (kbd "s") 'isearch-forward)


  ;------------------ operators -------------------------
  (define-key devil-mode-map (kbd "c") 'kill-ring-save)  
  (define-key devil-mode-map (kbd "x") 'kill-region)
  (define-key devil-mode-map (kbd "d") 'kill-region)


  ;------------------- others -----------------------------
  (define-key devil-mode-map (kbd "TAB") 'exchange-point-and-mark)
  (define-key devil-mode-map (kbd "h k") 'describe-key)
  (define-key devil-mode-map (kbd "h f") 'describe-function)
  (define-key devil-mode-map (kbd "SPC") 'keyboard-quit)
  )

  (set-temporary-overlay-map devil-mode-map t)
)


;;             toggle keymap
;; ------------------------------
(defun devil-activate-selection-state ()
   (devil-add-selection-keymap)
)

(defun devil-deactivate-selection-state ()
)

(add-hook 'activate-mark-hook 'devil-activate-selection-state)

(add-hook 'activate-mark-hook 'devil-deactivate-selection-state)


;;         define mode
;; ------------------------------

(define-minor-mode devil-mode
  "Easily navigate while text is selected"
 :lighter " dev"
)


(provide 'devil-mode)
