; Principle
; - ErgoEmacs Component for ^x motion, ^c motion
; - ErgoEmacs Theme for paddle etc...

(require 'ergoemacs-mode)

(add-to-list 'load-path "./")
(require 'bodhi-common)


; ----------- COMMANDS ---------------------

 (defun bodhi-copy-line (arg)
    "Copy lines (as many as prefix argument) in the kill ring.
      Ease of use features:
      - Move to start of next line.
      - Appends the copy on sequential calls.
      - Use newline as last char even on the last line of the buffer.
      - If region is active, copy its lines."
    (interactive "p")
    (let ((beg (line-beginning-position))
          (end (line-end-position arg)))
      (when mark-active
        (if (> (point) (mark))
            (setq beg (save-excursion (goto-char (mark)) (line-beginning-position)))
          (setq end (save-excursion (goto-char (mark)) (line-end-position)))))
      (if (eq last-command 'copy-line)
          (kill-append (buffer-substring beg end) (< end beg))
        (kill-ring-save beg end)))
    (kill-append "\n" nil)
    (beginning-of-line (or (and arg (1+ arg)) 2))
    (if (and arg (not (= 1 arg))) (message "%d lines copied" arg)))



; ------------- COMPONENTS ---------------------------

(ergoemacs-theme-component cua-prompters ()
  "Use cua-inspired keys: s[ave], z[undo], [f]ind, [r]eplace"
  (global-set-key (kbd "C-s") 'save-buffer)
  (global-set-key (kbd "C-z") 'undo)

  (global-set-key (kbd "C-f") 'bodhi-find-prompt)
  (global-set-key (kbd "C-r") 'bodhi-replace-prompt)
  (global-set-key (kbd "C-g") 'bodhi-global-prompt)
)


(ergoemacs-theme-component operator-motion ()
  "Use operator motion commands."
  (global-set-key (kbd "C-c c") 'body-copy-line)
  (global-set-key (kbd "C-x x") 'kill-whole-line)
  (global-set-key (kbd "C-x o") 'kill-word)
  (global-set-key (kbd "C-x $") 'kill-line)
  (global-set-key (kbd "C-x w") 'kill-word))



(ergoemacs-theme-component perl-motions ()
  "Part of vim-like perl motions."
  (global-set-key (kbd "$")   'end-of-line)
  (global-set-key (kbd "C-$") 'end-of-line)
  (global-set-key (kbd "M-$") 'kill-line)

  (global-set-key (kbd "C-à") 'beginning-of-line)
  (global-set-key (kbd "C-^") 'beginning-of-line)
  (global-set-key (kbd "M-à") 'bodhi-backward-kill-line))

; -------------- THEME ----------------------------

(ergoemacs-theme bodhi ()
  "Bodhi Ergoemacs Theme"
  :components   '(cua-prompters
                  ergoemacs-remap
                  move-char
                  perl-motions)
  :optional-on  '(operator-motion)
  :optional-off '(guru no-backspace)
  :options-menu '(("Extreme ErgoEmacs" (guru no-backspace)
		   ("Operator>Motion" (operator-motion))))
)

(provide 'ee-bodhi)

