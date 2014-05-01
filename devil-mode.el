;;          VARS
;; --------------------------------------------
(defvar devil-mode-map nil "Keymap for devil-mode")


;; -----------COMMANDS -----------------
(defun devil-search-foward ()
 (interactive)
 (isearch-forward-regexp)
 (devil-add-selection-keymap)
)


(defun devil-search-backward ()
 (interactive)
 (isearch-backward-regexp)
 (devil-add-selection-keymap)
)


(defun devil-back-to-indentation ()
  (interactive)
  (if (= (point) (progn (back-to-indentation) (point)))
    (beginning-of-line))
)


;-----------------------------------------------

(defun devil-add-selection-keymap ()
  (when (not devil-mode-map)
  (setq devil-mode-map (make-sparse-keymap))

  ;------------------ moves -------------------------
  (define-key devil-mode-map (kbd "l") 'forward-char)
  (define-key devil-mode-map (kbd "j") 'backward-char)
  (define-key devil-mode-map (kbd "k") 'next-line)
  (define-key devil-mode-map (kbd "i") 'previous-line)
  (define-key devil-mode-map (kbd "$") 'end-of-line)
  (define-key devil-mode-map (kbd "0") 'beginning-of-line)
  (define-key devil-mode-map (kbd "^") 'devil-back-to-indentation)
  (define-key devil-mode-map (kbd "w") 'forward-word)
  (define-key devil-mode-map (kbd "b") 'backward-word)

  (define-key devil-mode-map (kbd "s") 'devil-search-foward)
  (define-key devil-mode-map (kbd "r") 'devil-search-backward)

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


  ;-------------- hooks, mode ----------------

(defun devil-activate-selection-state ()
   (devil-add-selection-keymap)
)

(defun devil-deactivate-selection-state ()
)

(add-hook 'activate-mark-hook 'devil-activate-selection-state)

(add-hook 'activate-mark-hook 'devil-deactivate-selection-state)



(define-minor-mode devil-mode
  "Easily navigate while text is selected"
 :lighter " dev"
)


(provide 'devil-mode)
